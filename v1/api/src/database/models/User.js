const mongoose = require("mongoose");

var EmailVerificationSchema = new mongoose.Schema(
  {
    isConfirmed: {
      type: Boolean,
      default: false,
    },
    email: {
      type: String,
      required: true,
    },
    pin: {
      type: String,
      required: true,
    },
  },
  { _id: false, timestamps: true }
);

const Schema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    photo: {
      type: Object,
    },
    password: {
      type: String,
      required: true,
    },
    emailVerification: {
      type: [EmailVerificationSchema],
    },
    scope: {
      type: Array,
      default: ["GUEST"],
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", Schema);
