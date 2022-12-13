"use strict";

var internals = {};
const Place = require("../../database/models/Place");
const Review = require("../../database/models/Review");
const Favorite = require("../../database/models/Favorite");
const {
  getUrlsArray,
  deleteFiles,
} = require("../../libraries/aws-s3-storage-upload");
const mongoose = require("mongoose");

internals.places = async (req, reply) => {
  let userId = req.auth.credentials?._id;
  console.log("UPDATE SIGN!!!!!");

  try {
    let query = [
      {
        $lookup: {
          from: "categories",
          localField: "categoryId",
          foreignField: "_id",
          as: "categoryId",
        },
      },
      {
        $unwind: "$categoryId",
      },
      {
        $lookup: {
          from: "reviews",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $group: {
                _id: "$placeId",
                rating: { $sum: "$rating" },
                count: { $sum: 1 },
              },
            },
            {
              $project: {
                _id: 0,
                average: { $divide: ["$rating", "$count"] },
                reviewerCount: "$count",
              },
            },
          ],
          as: "reviewsStat",
        },
      },
    ];
    let filters = [];

    let { searchKey, mode } = req.query;

    if (searchKey) {
      var re = new RegExp(searchKey, "i");
      filters.push({
        $or: [
          { name: { $regex: re } },
          { address: { $regex: re } },
          { "categoryId.name": { $regex: re } },
        ],
      });
    }

    if (mode == "popular") {
      query.push({
        $lookup: {
          from: "favorites",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $group: {
                _id: 1,
                count: { $sum: 1 },
              },
            },
          ],
          as: "favorites",
        },
      });
      query.push({
        $unwind: "$favorites",
      });
      query.push({
        $sort: { "favorites.count": -1 },
      });
    }

    if (mode == "new") {
      query.push({ $sort: { createdAt: -1 } });
    }

    if (mode == "top_rated") {
      query.push({
        $unwind: "$reviewsStat",
      });
      query.push({
        $sort: { "reviewsStat.average": -1 },
      });
    }

    if (userId) {
      query.push({
        $lookup: {
          from: "favorites",
          localField: "_id",
          foreignField: "placeId",
          pipeline: [
            {
              $match: {
                userId: userId,
              },
            },
            { $limit: 1 },
          ],
          as: "isLiked",
        },
      });
    }

    if (filters.length > 0) {
      query.push({
        $match: {
          $and: filters,
        },
      });
    }

    let places = await Place.aggregate(query);
    return reply
      .response({
        message: "Places fetched successfully",
        data: {
          places,
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.place_info = async (req, reply) => {
  let userId = req.auth.credentials?._id;

  try {
    let _place = await Place.findOne({
      _id: req.params.id,
    }).populate("categoryId");

    if (!_place) {
      return reply
        .response({
          message: "Place not found",
        })
        .code(404);
    }

    let place = JSON.parse(JSON.stringify(_place));
    if (userId) {
      let isLiked = await Favorite.countDocuments({
        userId,
        placeId: req.params.id,
      });
      place.isLiked = isLiked > 0;
    }

    let reviewsStat = await Review.aggregate([
      { $match: { placeId: mongoose.Types.ObjectId(req.params.id) } },
      {
        $group: { _id: 0, rating: { $sum: "$rating" }, count: { $sum: 1 } },
      },
      {
        $project: {
          _id: 0,
          average: { $divide: ["$rating", "$count"] },
          reviewerCount: "$count",
        },
      },
    ]);

    place.reviewsStat = reviewsStat;

    let review = await Review.find({
      placeId: req.params.id,
    })
      .limit(1)
      .sort({ createdAt: -1 })
      .populate({
        path: "placeId",
        populate: {
          path: "categoryId",
        },
      })
      .populate("userId");

    return reply
      .response({
        message: "Place fetched successfully",
        data: {
          place,
          review: review?.[0],
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.like_place = async (req, reply) => {
  let userId = req.auth.credentials._id;
  let placeId = req.params.id;

  try {
    let hasAlreadyLiked = await Favorite.findOne({
      userId,
      placeId,
    });

    if (hasAlreadyLiked) {
      await Favorite.deleteOne({
        userId,
        placeId,
      });
      return reply
        .response({
          message: "Place unliked.",
          data: {
            isLiked: false,
          },
        })
        .code(200);
    } else {
      await Favorite({
        userId,
        placeId,
      }).save();
      return reply
        .response({
          message: "Placed liked.",
          data: {
            isLiked: true,
          },
        })
        .code(200);
    }
  } catch (e) {
    return reply
      .response({
        message: "Error in the server",
      })
      .code(500);
  }
};

internals.place_review_add = async (req, reply) => {
  let userId = req.auth.credentials._id;
  let payload = req.payload;

  let newReview = Review({
    userId,
    ...payload,
  });

  if (!Array.isArray(payload.photos) && payload.photos)
    payload.photos = [payload.photos];

  if (Array.isArray(payload.photos) && payload.photos.length != 0) {
    let photosUrl = await getUrlsArray(payload.photos, newReview._id, "review");
    newReview.photos = photosUrl;
  }

  if (!payload?.photos) {
    delete payload.photos;
  }

  try {
    await newReview.save();
    return reply
      .response({
        message: "Review added",
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

internals.places_reviews_list = async (req, reply) => {
  let placeId = req.params.id;

  try {
    let reviews = await Review.find({ placeId })
      .sort({ createdAt: -1 })
      .populate({
        path: "placeId",
        populate: {
          path: "categoryId",
        },
      })
      .populate("userId");

    return reply
      .response({
        data: {
          reviews,
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

internals.delete_photo = async (req, reply) => {
  let { dataId, schema, link } = req.query;
  let SCHEMA;

  if (schema == "place") {
    SCHEMA = Place;
  }

  try {
    // let _link = link.replace(
    //   "https://tourdelantapan.s3.ap-northeast-1.amazonaws.com/",
    //   ""
    // );
    // let link_ = _link.slice(0, _link.lastIndexOf("/"));
    // await deleteFiles(link_);

    await SCHEMA.updateOne(
      { _id: dataId },
      {
        $pull: { photos: { large: link } },
      },
      { safe: true, upsert: true }
    );

    return reply
      .response({
        message: "Photo deleted.",
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

internals.edit_place = async (req, reply) => {
  let payload = req.payload;
  var coordinates =
    payload?.latitude && payload?.longitude
      ? {
          latitude: parseFloat(payload.latitude),
          longitude: parseFloat(payload.longitude),
        }
      : null;

  var photoQuery = {};
  if (!Array.isArray(payload.photos) && payload.photos)
    payload.photos = [payload.photos];

  if (Array.isArray(payload.photos) && payload.photos.length != 0) {
    let photosUrl = await getUrlsArray(payload.photos, payload._id, "place");
    if (photosUrl && photosUrl?.length != 0) {
      photoQuery = {
        $push: {
          photos: { $each: photosUrl },
        },
      };
    }
    delete payload.photos;
  }

  if (!payload?.photos) {
    delete payload.photos;
  }

  try {
    await Place.updateOne(
      {
        _id: payload._id,
      },
      {
        ...payload,
        timeTable: JSON.parse(payload.timeTable),
        coordinates: coordinates ?? payload.coordinates,
        ...photoQuery,
      }
    );
    return reply
      .response({
        message: "Place updated",
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

internals.delete_place = async (req, reply) => {
  let placeId = req.params.id;

  try {
    await Place.deleteOne({ _id: placeId });
    return reply
      .response({
        message: "Place deleted",
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

internals.get_all_place_ids = async (req, reply) => {
  try {
    let placeIds = await Place.find({}).select("_id");
    return reply
      .response({
        data: {
          placeIds,
        },
      })
      .code(200);
  } catch (e) {
    console.log(e);
    return reply
      .response({
        message: "Server error",
      })
      .code(500);
  }
};

module.exports = internals;
