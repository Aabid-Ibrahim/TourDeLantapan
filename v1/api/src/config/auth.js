"use strict";

var internals = {},
  config = require("../config"),
  User = require("../database/models/User");

internals.validate = async (decodedToken, req, h) => {
  return User.findById(decodedToken.id)
    .then((res) => ({ isValid: true, credentials: res }))
    .catch((err) => ({ isValid: false, credentials: {} }));
};

internals.setAuthStrategy = async function (server) {
  await server.register({
    plugin: require("hapi-auth-jwt2"),
  });

  server.auth.strategy("token", "jwt", {
    key: config.crypto.privateKey,
    validate: internals.validate,
  });

  server.auth.default("token");
};

module.exports = {
  setStrategy: internals.setAuthStrategy,
};
