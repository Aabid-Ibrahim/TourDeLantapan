var AWS = require("aws-sdk");
const sharp = require("sharp");
const { aws_credentials } = require("../config");

var sizes = {
  thumbnail: 200,
  small: 400,
  medium: 600,
  large: 1200,
  // original: null
};

AWS.config.update(aws_credentials);

const getUrlsArray = async (file, name, folder) => {
  var photoArr = [];
  var count = file.length;

  for (var i = 0; i < count; i++) {
    let millis = Date.now("millis");
    let filebuffer = file[i].path;
    let fileExtension = file[i].filename.substr(
      file[i].filename.lastIndexOf(".")
    );

    photoArr.push(
      await getSizesSet(
        filebuffer,
        fileExtension,
        `${name}/${name}_${millis}/${name}_${millis}`,
        folder
      )
    );
  }

  return photoArr;
};

const getUrls = async (file, name, folder) => {
  let filebuffer = file.path;
  let fileExtension = file.filename.substr(file.filename.lastIndexOf("."));

  return getSizesSet(filebuffer, fileExtension, `${name}/${name}`, folder);
};

const getUrlsWithParent = async (file, parent, name, folder) => {
  let filebuffer = file.path;
  let fileExtension = file.filename.substr(file.filename.lastIndexOf("."));
  return getSizesSet(
    filebuffer,
    fileExtension,
    `${parent}/${name}/${name}`,
    folder
  );
};

const getSizesSet = async (filebuffer, fileExtension, name, folder) => {
  var promises = [];

  var init = upload(filebuffer, fileExtension, name, folder);
  for (var i = 0; i <= 3; i++) {
    promises.push(init(i));
  }

  let urls = await Promise.all(promises);
  return {
    thumbnail: urls[0],
    small: urls[1],
    medium: urls[2],
    large: urls[3],
    original: urls[3],
  };
};

const placeHolder = {
  thumbnail:
    "https://visitour.s3.ap-southeast-1.amazonaws.com/Placeholder/visitour-logo/visitour-logo_thumbnail.jpeg",
  small:
    "https://visitour.s3.ap-southeast-1.amazonaws.com/Placeholder/visitour-logo/visitour-logo_small.jpeg",
  medium:
    "https://visitour.s3.ap-southeast-1.amazonaws.com/Placeholder/visitour-logo/visitour-logo_medium.jpeg",
  large:
    "https://visitour.s3.ap-southeast-1.amazonaws.com/Placeholder/visitour-logo/visitour-logo_large.jpeg",
  original:
    "https://visitour.s3.ap-southeast-1.amazonaws.com/Placeholder/visitour-logo/visitour-logo_original.jpeg",
};

const upload = (filePath, fileExtension, name, folder) => (i) =>
  new Promise(async (resolve, reject) => {
    let resizedPhoto;
    let size;

    console.log(aws_credentials.bucket);
    console.log(`Resizing a JPEG Image - ${fileExtension}`);
    size = Object.values(sizes)[i];
    resizedPhoto = await sharp(filePath, { failOnError: true })
      .resize({ width: size })
      .withMetadata()
      .toBuffer();

    let sizeName = Object.keys(sizes)[i];
    var objectParams = {
      Bucket: aws_credentials.bucket,
      Key: `${folder}/${name}_${sizeName}${fileExtension}`,
      Body: resizedPhoto,
    };

    var s3bucket = new AWS.S3({ params: { Bucket: aws_credentials.bucket } });
    s3bucket.upload(objectParams, function (err, data) {
      if (err) {
        console.log("ERROR MSG: ", err);
        reject(err);
      } else {
        console.log("Successfully Uploaded Data to S3 Bucket.");
        resolve(data.Location);
      }
    });
  });

const deleteFiles = (pathToFile) =>
  new Promise((resolve, reject) => {
    setTimeout(async () => {
      var s3 = new AWS.S3();

      const listParams = {
        Bucket: aws_credentials.bucket,
        Prefix: pathToFile,
      };

      const listedObjects = await s3.listObjectsV2(listParams).promise();

      if (listedObjects.Contents.length === 0) {
        resolve({ success: true, message: "Directory is empty." });
        return;
      }

      const deleteParams = {
        Bucket: aws_credentials.bucket,
        Delete: { Objects: [] },
      };

      listedObjects.Contents.forEach(({ Key }) => {
        deleteParams.Delete.Objects.push({ Key });
      });

      var res = await s3.deleteObjects(deleteParams).promise();

      console.log(res);

      if (res.Deleted.length != 0)
        resolve({ success: true, message: "Deletion Successful!" });
      if (res.Errors.length != 0)
        reject({ success: false, message: "An error occurred", res });
    }, 2000);
  });

module.exports = {
  getUrls,
  getUrlsArray,
  getUrlsWithParent,
  placeHolder,
  deleteFiles,
};
