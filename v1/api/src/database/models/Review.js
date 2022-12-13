const mongoose = require("mongoose");
require("./Category");
require("./Place");

const Schema = new mongoose.Schema(
  {
    rating: {
      type: Number,
      required: true,
    },
    content: {
      type: String,
      required: true,
    },
    photos: {
      type: Array,
    },
    placeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Place",
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Review", Schema);
