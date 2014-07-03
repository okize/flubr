var Twit, User, path, twitter;

path = require('path');

Twit = require('twit');

twitter = new Twit({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token: process.env.TWITTER_ACCESS_TOKEN,
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
});

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
    return twitter.get('users/show', {
      screen_name: req.body.user
    }, function(err, data, res) {
      var user;
      if (err) {
        throw err;
      }
      user = new User();
      user.userid = data.id;
      user.userName = data.screen_name;
      user.displayName = data.name;
      user.avatar = data.profile_image_url;
      return User.find({
        userid: user.userid
      }, function(err, results) {
        if (err) {
          throw err;
        }
        if (!results.length) {
          return user.save(function(err) {
            if (err != null) {
              res.send(500, {
                error: err
              });
            }
            return res.send(user);
          });
        } else {
          return res.send(500, {
            error: 'user already exists'
          });
        }
      });
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
        return res.send(results);
      }
    });
  },
  "delete": function(req, res) {
    return User.findOneAndRemove({
      userid: req.params.id
    }, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      if (results != null) {
        return res.send(200, results);
      }
    });
  }
};
