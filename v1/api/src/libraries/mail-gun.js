var config = require("../config");
var api_key = config?.mailgun?.api_key;
// var domain = "tourdelantapan.com";
var domain = "sandbox0b3f4875fcb04e3bbc3f1b9ec81223a2.mailgun.org";
var mailgun = require("mailgun-js")({ apiKey: api_key, domain: domain });
var fs = require("fs");
var Handlebars = require("handlebars");

module.exports.helper = mailgun;

module.exports.template = function (params, file) {
  (message = fs.readFileSync(file, "utf-8")),
    (template = Handlebars.compile(message)),
    (result = template(params));
  return result;
};

module.exports.send = (data, cb) => {
  mailgun.messages().send(data, function (err, body) {
    if (err) {
      console.log("err", err);
      cb(false);
    }
    console.log("email for", data.to, "queued successfully");
    cb(true);
  });
};
