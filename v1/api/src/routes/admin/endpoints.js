"use strict";
var Handlers = require("./handlers"),
  internals = {};

internals.endpoints = [
  {
    method: "POST",
    path: "/place/add",
    options: {
      payload: {
        output: "file",
        parse: true,
        multipart: true,
        maxBytes: 100000000000,
      },
      handler: Handlers.add_place,
      auth: {
        strategy: "token",
      },
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/count",
    handler: Handlers.admin_dashboard_count,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/likes",
    handler: Handlers.admin_dashboard_likes,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/admin/dashboard/ratings",
    handler: Handlers.admin_dashboard_ratings,
    config: {
      auth: "token",
    },
  },
  {
    method: "POST",
    path: "/visitor/form",
    handler: Handlers.visitor_form,
    config: {
      auth: false,
    },
  },
  {
    method: "GET",
    path: "/visitor/list",
    handler: Handlers.visitor_list,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/review/delete/{reviewId}",
    handler: Handlers.review_delete,
    config: {
      auth: "token",
    },
  },
  {
    method: "GET",
    path: "/nearby/gas-stations",
    handler: Handlers.nearby_gas_stations,
    config: {
      auth: false,
    },
  },
];

module.exports = internals;
