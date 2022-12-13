const mongoose = require("mongoose");

const Schema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
    },
    contactNumber: {
      type: String,
      required: true,
    },
    dateOfVisit: {
      type: Date,
      required: true,
    },
    address: {
      type: Object,
      required: true,
    },
    numberOfVisitors: {
      type: Number,
      required: true,
    },
    placeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Place",
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Visitor", Schema);
