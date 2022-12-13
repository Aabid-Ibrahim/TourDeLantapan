const mongoose = require("mongoose");
require("./Category");

const Schema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    address: {
      type: String,
      required: true,
    },
    coordinates: {
      type: Object,
      required: true,
    },
    categoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: true,
    },
    photos: {
      type: Array,
      default: [],
    },
    // status: {
    //   type: String,
    // },
    timeTable: {
      type: Array,
      default: [],
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Place", Schema);
