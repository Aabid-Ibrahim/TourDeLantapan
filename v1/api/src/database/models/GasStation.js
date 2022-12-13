const mongoose = require("mongoose");

const Schema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    photos: {
      type: Array,
    },
    coordinates: {
      type: {
        type: String,
        enum: ["Point"],
      },
      coordinates: {
        type: [Number],
      },
    },
  },
  { timestamps: true }
);

Schema.index({ coordinates: "2dsphere" });
module.exports = mongoose.model("GasStation", Schema);
