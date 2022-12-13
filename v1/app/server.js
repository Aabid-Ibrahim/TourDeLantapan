const express = require("express");
const path = require("path");
const app = express();
const cors = require("cors");

app.use(cors());

app.use(express.static(path.join(__dirname, "build", "web")));
app.get("/*", function (req, res) {
  res.sendFile(path.join(__dirname, "build", "web", "index.html"));
});

const port = process.env.PORT || 8000;
app.listen(port);

console.log(`Tour de Lantapan App is running on port http://localhost:${port}`);
