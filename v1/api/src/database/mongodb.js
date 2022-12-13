"use strict";

var Mongoose = require("mongoose"),
  Config = require("../config");

var connection_string = "";

connection_string =
  "mongodb+srv://" +
  Config.mongodb.username +
  ":" +
  Config.mongodb.password +
  "@" +
  Config.mongodb.clusterUrl +
  `/${Config.mongodb.db}` +
  "?retryWrites=true&w=majority";

console.log(Config.mongodb);
console.log(connection_string)
Mongoose.Promise = global.Promise;
Mongoose.connect(connection_string, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log(`MongoDB initialized successfully.`))
  .catch((err) => console.log(err));
