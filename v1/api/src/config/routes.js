"use strict";

var internals = {};

// Endpoints
let Auth = require("../routes/auth/endpoints");
let Places = require("../routes/places/endpoints");
let Admin = require("../routes/admin/endpoints");

internals.routes = [...Auth.endpoints, ...Places.endpoints, ...Admin.endpoints];

internals.init = function (server) {
  server.route(internals.routes);
};

module.exports = internals;
