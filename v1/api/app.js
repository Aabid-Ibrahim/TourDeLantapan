"use strict";

var HapiServer = require("./src/config/hapi");
var TransactionWatch = require("./src/libraries/transactionwatch/lib/transactionwatch");
var Mongoose = require("mongoose");

TransactionWatch.init(Mongoose);
require("./src/database/mongodb");

async function start() {
  var server = await HapiServer.deployment();

  console.log("server.info", server.info);
  console.log(`Server started attttttt ${server.info.uri}`);
  await server.start();
}

start();
