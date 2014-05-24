var mongoose, _;

mongoose = require('mongoose');

_ = require('lodash');

exports.create = function(req, res) {
  var Resource, fields, r;
  Resource = mongoose.model('Image');
  fields = req.body;
  r = new Resource(fields);
  return r.save(function(err, resource) {
    if (err != null) {
      res.send(500, {
        error: err
      });
    }
    return res.send(resource);
  });
};

exports.retrieve = function(req, res) {
  var Resource;
  Resource = mongoose.model('Image');
  if (req.params.type != null) {
    return Resource.find({
      kind: req.params.type
    }, 'image_url randomizer', function(err, resource) {
      var randomImage;
      randomImage = _.sample(resource);
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      if (randomImage != null) {
        return res.send(randomImage.image_url);
      }
    });
  } else {
    return Resource.find({}, function(err, coll) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(coll);
    });
  }
};
