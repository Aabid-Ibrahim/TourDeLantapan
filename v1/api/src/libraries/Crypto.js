/**
 * # ErrorAlert.js
 *
 * This class uses a component which displays the appropriate alert
 * depending on the platform
 *
 * The main purpose here is to determine if there is an error and then
 * plucking off the message depending on the shape of the error object.
 */
"use strict";
/**
 * ## Imports
 *
 */
// our configurations
var Config = require("../config"),
  //the crypto library
  crypto = require("crypto"),
  //algorithm for encryption
  algorithm = "aes-256-ctr",
  biz_algorithm = "aes-192-ctr",
  privateKey = Config.crypto.privateKey;

/**
 * ### public decrypt
 *
 */
exports.decrypt = function (password) {
  return decrypt(password);
};
/**
 * ### public encrypt
 *
 */
exports.encrypt = function (password) {
  return encrypt(password);
};

/**
 * ##  method to decrypt data(password)
 *
 */
function decrypt(password) {
  var decipher = crypto.createDecipher(algorithm, privateKey);
  var dec = decipher.update(password, "hex", "utf8");
  dec += decipher.final("utf8");
  return dec;
}
/**
 * ## method to encrypt data(password)
 *
 */
function encrypt(password) {
  var cipher = crypto.createCipher(algorithm, privateKey);
  var crypted = cipher.update(password, "utf8", "hex");
  crypted += cipher.final("hex");
  return crypted;
}

exports.biz_decrypt = function (acc) {
  return biz_decrypt(acc);
};

exports.biz_encrypt = function (acc) {
  return biz_encrypt(acc);
};

function biz_decrypt(acc) {
  var decipher = crypto.createDecipher(biz_algorithm, privateKey);
  var dec;
  try {
    var dec = decipher.update(acc, "hex", "utf8");
  } catch (e) {
    return acc;
  }
  dec += decipher.final("utf8");
  return dec;
}
/**
 * ## method to encrypt data(password)
 *
 */
function biz_encrypt(acc) {
  var cipher = crypto.createCipher(biz_algorithm, privateKey);
  var crypted = cipher.update(acc, "utf8", "hex");
  crypted += cipher.final("hex");
  return crypted;
}
