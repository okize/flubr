var Image, errors, path, _;

path = require('path');

_ = require('lodash');

Image = require(path.join('..', 'models', 'image'));

errors = {
  noIdError: "Please specify image type (pass/fail) in request url",
  noImageError: "No image found"
};

module.exports = {
  index: function(req, res) {
    return Image.find({}, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(results);
    });
  },
  random: function(req, res) {
    if ((req.params.id == null) || !req.params.id.match(/(pass|fail)/g)) {
      res.send(500, {
        error: errors.noIdError
      });
    }
    return Image.find({
      kind: req.params.id
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
    img = new Image(req.body);
    return img.save(function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(results);
    });
  },
  update: function(req, res) {
    return Image.findByIdAndUpdate(req.params.id, {
      $set: req.body
    }, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      if (results != null) {
        res.send(results);
      }
      return res.send(404);
    });
  },
  "delete": function(req, res) {
    return Image.findByIdAndRemove(req.params.id, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      if (results != null) {
        res.send(200, results);
      }
      return res.send(404);
    });
  }
};
