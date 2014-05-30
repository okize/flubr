var Image, errors, helpers, path, _;

path = require('path');

_ = require('lodash');

helpers = require(path.join('..', 'helpers'));

Image = require(path.join('..', 'models', 'image'));

errors = {
  noIdError: "Please specify image type (pass/fail) in request url",
  noImageError: "No image found"
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
    var img;
    if (helpers.checkForUser(req, res)) {
      req.body.added_by = req.user.userid;
      img = new Image(req.body);
      return img.save(function(err, results) {
        if (err != null) {
          res.send(500, {
            error: err
          });
        }
        return res.send(results);
      });
    } else {
      return res.send(500, {
        error: "Action requires user to be logged in"
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
        error: "Action requires user to be logged in"
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
        error: "Action requires user to be logged in"
      });
    }
  }
};
