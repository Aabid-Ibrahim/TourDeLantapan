"use strict";

var internals = {};
const User = require("../../database/models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Crypto = require("../../libraries/Crypto");
const Config = require("../../config");
const moment = require("moment");
const { getUrls } = require("../../libraries/aws-s3-storage-upload");
const { sendOTP, sendResetLink } = require("../../libraries/email-helper");

const baseUrl = "http://127.0.0.1:9000";

internals.profile = async (req, reply) => {
  try {
    if (!req?.auth?.credentials?.email) {
      return reply
        .response({
          message: "Data not found",
          data: {},
        })
        .code(201);
    }

    let _profile = await User.findOne({
      email: req.auth.credentials.email,
    });

    let profile = JSON.parse(JSON.stringify(_profile));
    delete profile.password;
    delete profile.__v;
    delete profile.createdAt;
    delete profile.updatedAt;

    return reply
      .response({
        message: "Success.",
        data: {
          profile,
        },
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        errorMessage: e,
      })
      .code(500);
  }
};

internals.profile_edit = async (req, reply) => {
  let payload = req.payload;
  delete payload?.email;

  if (!payload?.photos) {
    delete payload?.photos;
  } else {
    let photoUrl = await getUrls(payload.photos, payload._id, "user");
    payload.photo = photoUrl;
    delete payload?.photos;
  }

  try {
    await User.updateOne({ _id: payload._id }, payload);
    let user = await User.findOne({ _id: payload._id });
    let profile = JSON.parse(JSON.stringify(user));
    delete profile.password;
    delete profile.__v;
    delete profile.createdAt;
    delete profile.updatedAt;

    return reply
      .response({
        message: "Success.",
        data: {
          profile,
        },
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        errorMessage: e,
      })
      .code(500);
  }
};

internals.login = async (req, reply) => {
  const { email, password } = req.payload;

  try {
    let _profile = await User.findOne({ email });

    if (!_profile) {
      return reply
        .response({
          message: "Email not found.",
        })
        .code(404);
    }
    let validPass = await bcrypt.compare(password, _profile.password);
    if (!validPass) {
      return reply
        .response({
          message: "Incorrect password.",
        })
        .code(405);
    }

    let profile = JSON.parse(JSON.stringify(_profile));
    delete profile.password;
    delete profile?.__v;
    delete profile?.createdAt;
    delete profile?.updatedAt;

    return reply
      .response({
        message: "Success",
        data: {
          accessToken: jwt.sign({ id: profile._id }, Config.crypto.privateKey),
          ...profile,
        },
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

internals.signup = async (req, res) => {
  let newUser = User(req.payload);
  newUser.password = await bcrypt.hash(req.payload.password, 10);

  if (!req.payload.email.match(/.+@.+\.[A-Za-z]+$/))
    return res
      .response({
        message: "Invalid email format",
      })
      .code(422);
  if (req.payload.password?.length < 4)
    return res
      .response({
        message: "Password too short.",
      })
      .code(422);

  return await User.findOne({ email: req.payload.email }).then(
    (data, error) => {
      if (error)
        return res
          .response({
            message: "Error in the server",
          })
          .code(500);

      if (data)
        return res
          .response({
            message: "Email already taken.",
          })
          .code(409);
      else {
        return newUser
          .save()
          .then(async () => {
            return res
              .response({
                message: "Successfully signed up. You can log in now.",
              })
              .code(200);
          })
          .catch((err) => {
            console.log(err);
            return res
              .response({
                message: "There is an error in the server.",
              })
              .code(500);
          });
      }
    }
  );
};

internals.generate_otp = async (req, reply) => {
  let { email, recipient_name } = req.query;
  const OTP = Math.floor(100000 + Math.random() * 900000);

  try {
    await User.updateOne(
      { email },
      {
        $push: {
          emailVerification: {
            isConfirmed: false,
            email,
            pin: OTP,
          },
        },
      },
      { new: true }
    );
    sendOTP(email, {
      recipient_name,
      OTP,
    });
    return reply
      .response({
        message: "OTP has been sent.",
      })
      .code(200);
  } catch (err) {
    console.log(err);
    return reply
      .response({
        message: "Server error.",
      })
      .code(500);
  }
};

internals.confirm_pin = async (req, reply) => {
  let pin = req.params.pin;
  let { email } = req.query;

  try {
    let user = await User.findOne({ email });

    if (!user) {
      return reply
        .response({
          message: "User not found.",
        })
        .code(404);
    }

    if (user?.emailVerification?.length === 0) {
      return reply
        .response({
          message: "No confirm pin yet.",
        })
        .code(404);
    }

    var currentPin;
    let pins = user.emailVerification;
    for (let i = 0; i < pins.length; i++) {
      if (i < pins.length - 1) {
        if (pins?.[i]?.pin === pin) {
          return reply
            .response({
              message: "Pin expired.",
            })
            .code(404);
        }
      } else {
        currentPin = pins[i];
      }
    }

    if (moment().diff(currentPin?.createdAt, "minutes") > 30) {
      return reply
        .response({
          message: "Pin expires after 30 minutes. Request a new one.",
        })
        .code(404);
    }

    if (currentPin?.pin === pin) {
      user.emailVerification[
        user.emailVerification.length - 1
      ].isConfirmed = true;

      await user.save();

      let profile = JSON.parse(JSON.stringify(user));
      delete profile.password;
      delete profile?.__v;
      delete profile?.createdAt;
      delete profile?.updatedAt;

      return reply
        .response({
          message: "Pin is correct. Your email is now verified.",
          data: {
            profile,
          },
        })
        .code(200);
    } else {
      return reply
        .response({
          message: "Pin incorrect.",
        })
        .code(404);
    }
  } catch (error) {
    console.log("err", error);
    return reply
      .response({
        message: "An error occurred.",
      })
      .code(500);
  }
};

internals.email_reset_password = async (req, reply) => {
  console.log(req.query);
  try {
    let userData = await User.findOne({ email: req.query.email });
    if (userData) {
      let token = Crypto.encrypt(
        JSON.stringify({ userId: userData._id, createdAt: moment().valueOf() })
      );
      sendResetLink(
        req.query.email,
        `${baseUrl}/user/reset-password-form/${token}`
      );
      return reply
        .response({
          message: `Email has been sent to ${req.query.email}.`,
        })
        .code(200);
    } else {
      return reply
        .response({
          message: "There is no registered user with this email.",
        })
        .code(404);
    }
  } catch (error) {
    console.log(error);
    return reply
      .response({
        message: "Server error.",
      })
      .code(500);
  }
};

internals.reset_password_form = async (req, reply) => {
  let data = JSON.parse(Crypto.decrypt(req.params.token));
  if (moment(data.createdAt).isAfter(moment().subtract(1, "hours"))) {
    return reply
      .view("auth/reset-password-form.html", {
        userId: data.userId,
        tokenHasExpired: false,
      })
      .code(200);
  } else {
    return reply
      .view("auth/reset-password-form.html", {
        tokenHasExpired: true,
      })
      .code(200);
  }
};

internals.initiate_password_reset = async (req, reply) => {
  try {
    let userData = await User.findOne({ _id: req.params.userId });
    if (userData) {
      userData.password = await bcrypt.hash(req.payload.password, 10);
      await userData.save();

      return reply
        .response({
          success: true,
          message: "Your password reset has been successful.",
        })
        .code(200);
    } else {
      return reply
        .response({
          message: "User not found.",
        })
        .code(404);
    }
  } catch (error) {
    return reply
      .response({
        message: "Server error.",
      })
      .code(500);
  }
};

internals.change_password = async (req, reply) => {
  let userId = req.auth.credentials._id;
  let oldPassword = req.payload.oldPassword;
  let newPassword = req.payload.newPassword;

  try {
    let user = await User.findOne({ _id: userId });
    let validPass = await bcrypt.compare(oldPassword, user.password);

    if (!validPass) {
      return reply
        .response({
          message: "Old password is incorrect.",
        })
        .code(401);
    }

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();

    return reply
      .response({
        message: "Password has been successfully changed. Log in again.",
      })
      .code(200);
  } catch (e) {
    return reply
      .response({
        message: "Server error.",
      })
      .code(500);
  }
};

module.exports = internals;
