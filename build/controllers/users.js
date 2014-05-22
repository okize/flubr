var User, path;

path = require('path');

User = require(path.join('..', 'models', 'user'));

module.exports = {
  index: function(req, res) {
    return User.find({}, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(results);
    });
  },
  create: function(req, res) {
    var img;
    img = new User(req.body);
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
    return User.findByIdAndUpdate(req.params.id, {
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
    return User.findByIdAndRemove(req.params.id, function(err, results) {
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
