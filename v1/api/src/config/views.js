"use strict";

var Handlebars = require("handlebars"),
  internals = {},
  Path = require("path"),
  Vision = require("vision"),
  Inert = require("@hapi/inert");

internals.init = async function (server) {
  await server.register(Vision);
  server.views({
    engines: {
      html: Handlebars,
    },
    isCached: false,
    relativeTo: __dirname,
    path: Path.join(__dirname, "../views"),
    layout: false,
    // layoutPath: Path.join(__dirname, "../views/layout"),
    // partialsPath: "../views/partials",
    // helpersPath: "../views/helpers",
  });

  Handlebars.registerHelper("ifEquals", function (arg1, arg2, options) {
    return arg1 == arg2 ? options.fn(this) : options.inverse(this);
  });

  Handlebars.registerHelper("ifNotEquals", function (arg1, arg2, options) {
    return arg1 != arg2 ? options.fn(this) : options.inverse(this);
  });

  await server.register(Inert);
  //Load files located in ../assets
  server.route({
    method: "GET",
    path: "/assets/{param*}",
    config: {
      auth: false,
    },
    handler: {
      directory: {
        path: Path.join(__dirname, "../assets"),
      },
    },
  });
};

module.exports = internals;
