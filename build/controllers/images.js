var Image, async, checkUrlIsImage, errors, help, path, request, _;

path = require('path');

_ = require('lodash');

help = require(path.join('..', 'helpers'));

Image = require(path.join('..', 'models', 'image'));

request = require('request');

async = require('async');

checkUrlIsImage = function(url) {
  return url.match(/\.(jpeg|jpg|gif|png)$/) !== null;
};

errors = {
  needToLogin: 'Action requires user to be authenticated',
  noIdError: 'Please specify image type (pass/fail) in request url',
  noImageError: 'No image found',
  noImageUrlSent: 'No image url specified',
  invalidImageUrl: 'That does not appear to be a valid image url'
};

module.exports = {
  index: function(req, res) {
    return Image.find({
      deleted: false
    }).sort({
      created_at: 'descending'
    }).exec(function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(results);
    });
  },
  indexDeleted: function(req, res) {
    return Image.find({
      deleted: true
    }).sort({
      created_at: 'descending'
    }).exec(function(err, results) {
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
    if (help.checkForUser(req, res)) {
      url = req.body.source_url;
      if (url === void 0 || url === '') {
        return res.send(422, {
          error: errors.noImageUrlSent
        });
      } else if (!checkUrlIsImage(url)) {
        return res.send(422, {
          error: errors.invalidImageUrl
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
                  'Content-Type': 'application/x-www-form-urlencoded',
                  Accept: 'application/json'
                }
              };
              return request.post(options, function(err, response, body) {
                if (err) {
                  callback(err, null);
                }
                data = JSON.parse(body);
                if (!data.success) {
                  return callback(data.data.error, null);
                } else {
                  return callback(null, data.data.link);
                }
              }).form(data);
            } else {
              return callback(null, url);
            }
          }
        ], function(err, results) {
          var img;
          if (err != null) {
            return res.send(500, {
              error: err
            });
          } else {
            req.body.added_by = req.user.userid;
            req.body.image_url = results[0];
            img = new Image(req.body);
            return img.save(function(err, results) {
              if (err != null) {
                res.send(500, {
                  error: err
                });
              }
              return res.send(201, results);
            });
          }
        });
      }
    } else {
      return res.send(401, {
        error: errors.needToLogin
      });
    }
  },
  update: function(req, res) {
    var updateData;
    if (help.checkForUser(req, res)) {
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
      return res.send(401, {
        error: errors.needToLogin
      });
    }
  },
  "delete": function(req, res) {
    var updateData;
    if (help.checkForUser(req, res)) {
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
      return res.send(401, {
        error: errors.needToLogin
      });
    }
  }
};
