var Image, async, errors, helpers, path, request, _;

path = require('path');

_ = require('lodash');

helpers = require(path.join('..', 'helpers'));

Image = require(path.join('..', 'models', 'image'));

request = require('request');

async = require('async');

errors = {
  noIdError: "Please specify image type (pass/fail) in request url",
  noImageError: "No image found",
  noImageUrlSent: "No image url sent",
  needToLogin: "Action requires user to be logged in"
};

module.exports = {
  index: function(req, res) {
    return Image.find({
      deleted: false
    }, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(results);
    });
  },
  show: function(req, res) {
    return Image.findById(req.params.id, function(err, result) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(result);
    });
  },
  random: function(req, res) {
    if ((req.params.id == null) || !req.params.id.match(/(pass|fail)/g)) {
      res.send(500, {
        error: errors.noIdError
      });
    }
    return Image.find({
      kind: req.params.id,
      deleted: false
    }, 'image_url', function(err, results) {
      var randomImage;
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      randomImage = _.sample(results);
      if (!(randomImage == null)) {
        return res.send(randomImage.image_url);
      } else {
        return res.send(500, {
          error: errors.noImageError
        });
      }
    });
  },
  create: function(req, res) {
    var url;
    if (helpers.checkForUser(req, res)) {
      url = req.body.source_url;
      if (url === void 0 || url === '') {
        return res.send(500, {
          error: errors.noImageUrlSent
        });
      } else {
        return async.series([
          function(callback) {
            var data, options;
            if (!url.match(/imgur.com/)) {
              data = {
                image: url,
                type: 'url'
              };
              options = {
                url: 'https://api.imgur.com/3/image',
                headers: {
                  Authorization: "Client-ID " + process.env.IMGUR_CLIENTID,
                  "Content-Type": 'application/x-www-form-urlencoded',
                  Accept: 'application/json'
                }
              };
              return request.post(options, function(error, response, body) {
                return callback(null, (JSON.parse(body)).data.link);
              }).form(data);
            } else {
              return callback(null, url);
            }
          }
        ], function(err, results) {
          var img;
          req.body.added_by = req.user.userid;
          req.body.image_url = results[0];
          img = new Image(req.body);
          return img.save(function(err, results) {
            if (err != null) {
              res.send(500, {
                error: err
              });
            }
            return res.send(results);
          });
        });
      }
    } else {
      return res.send(500, {
        error: needToLogin
      });
    }
  },
  update: function(req, res) {
    var updateData;
    if (helpers.checkForUser(req, res)) {
      updateData = {
        kind: req.body.kind,
        updated_by: req.user.userid
      };
      return Image.update({
        _id: req.params.id
      }, updateData, function(err, count) {
        if (err != null) {
          res.send(500, {
            error: err
          });
        }
        return res.send(200, {
          success: "" + count + " rows have been updated"
        });
      });
    } else {
      return res.send(500, {
        error: needToLogin
      });
    }
  },
  "delete": function(req, res) {
    var updateData;
    if (helpers.checkForUser(req, res)) {
      updateData = {
        deleted: true,
        deleted_by: req.user.userid
      };
      return Image.update({
        _id: req.params.id
      }, updateData, function(err, count) {
        if (err != null) {
          res.send(500, {
            error: err
          });
        }
        return res.send(200, {
          success: "" + count + " rows have been deleted"
        });
      });
    } else {
      return res.send(500, {
        error: needToLogin
      });
    }
  }
};
