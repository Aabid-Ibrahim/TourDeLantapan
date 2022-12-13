"use strict";

var Hapi = require("@hapi/hapi"),
  Routes = require("./routes"),
  Path = require("path"),
  Inert = require("@hapi/inert"),
  Auth = require("./auth"),
  Views = require("./views"),
  logger = require("node-color-log"),
  moment = require("moment");

var internals = {};

exports.deployment = async () => {
  // Start Hapi Server
  internals.server = new Hapi.Server({ debug: { request: ["error"] } });
  internals.server.payload = Buffer.alloc(104857610);

  // Host and Port Config
  internals.server = new Hapi.Server({
    port: process.env.PORT || 9000,
    routes: {
      cors: {
        origin: ["*"], // an array of origins or 'ignore'
      },
    },
  });

  internals.server.events.on("response", function (request) {
    let codeColor;
    if (request.response.statusCode < 199) {
      codeColor = "white";
    } else if (request.response.statusCode < 299) {
      codeColor = "green";
    } else if (request.response.statusCode < 399) {
      codeColor = "orange";
    } else if (request.response.statusCode < 499) {
      codeColor = "red";
    } else if (request.response.statusCode < 599) {
      codeColor = "yellow";
    }
    const responseTime = moment(request.response.headers?.["x-res-end"]).diff(
      moment(request.response.headers?.["x-req-start"]),
      "milliseconds",
      true
    );
    logger
      .color("white")
      .log(`${request.info.remoteAddress} : `)
      .joint()
      .color("yellow")
      .log(`[${request.method.toUpperCase()}]`)
      .joint()
      .color("green")
      .log(` ${request.path} `)
      .joint()
      .bgColor(codeColor)
      .log(`${request.response.statusCode}`)
      .joint()
      .color("white")
      .log(` ${responseTime}ms`);
  });

  await internals.server.register(require("hapi-response-time"));

  // Set Authentication Strategy
  await Auth.setStrategy(internals.server);

  await internals.server.register(Inert);
  internals.server.route({
    method: "GET",
    path: "/images/{filename}",
    handler: function (request, h) {
      return h.file(
        Path.join(__dirname, "../assets", "images", request.params.filename)
      );
    },
    config: {
      auth: false,
    },
  });

  // Set Views
  await Views.init(internals.server);

  // Set Routes
  Routes.init(internals.server);

  return internals.server;
};
