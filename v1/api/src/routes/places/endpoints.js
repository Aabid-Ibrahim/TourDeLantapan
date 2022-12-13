"use strict";
var Handlers = require("./handlers"),
  internals = {};

internals.endpoints = [
  {
    method: ["GET"],
    path: "/places",
    options: {
      handler: Handlers.places,
      auth: {
        mode: "try",
      },
    },
  },
  {
    method: ["GET"],
    path: "/places/{id}",
    options: {
      handler: Handlers.place_info,
      auth: {
        mode: "try",
      },
    },
  },
  {
    method: ["GET"],
    path: "/places/like/{id}",
    handler: Handlers.like_place,
    config: {
      auth: "token",
    },
  },
  {
    method: ["POST"],
    path: "/places/review/add/{id}",
    options: {
      payload: {
        output: "file",
        parse: true,
        multipart: true,
        maxBytes: 100000000000,
      },
      handler: Handlers.place_review_add,
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: ["GET"],
    path: "/places/reviews/{id}",
    handler: Handlers.places_reviews_list,
    config: {
      auth: false,
    },
  },
  {
    method: ["GET"],
    path: "/photo/delete",
    handler: Handlers.delete_photo,
    config: {
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: "POST",
    path: "/place/edit",
    options: {
      payload: {
        output: "file",
        parse: true,
        multipart: true,
        maxBytes: 100000000000,
      },
      handler: Handlers.edit_place,
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: ["GET"],
    path: "/place/delete/{id}",
    handler: Handlers.delete_place,
    config: {
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: ["GET"],
    path: "/place/all-ids",
    handler: Handlers.get_all_place_ids,
    config: {
      auth: false,
    },
  },
];

module.exports = internals;
