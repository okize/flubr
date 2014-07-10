var Twit, User, help, path, twitter;

path = require('path');

Twit = require('twit');

twitter = new Twit({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token: process.env.TWITTER_ACCESS_TOKEN,
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
});

User = require(path.join('..', 'models', 'user'));

help = require(path.join('..', 'helpers'));

module.exports = {
  index: function(req, res) {
    return User.find({}, function(err, results) {
      if (err != null) {
        res.send(500, {
          error: err
        });
      }
      return res.send(200, results);
    });
  },
  create: function(req, res) {
    return twitter.get('users/show', {
      screen_name: req.body.user
    }, function(err, data) {
      var user;
      if ((err != null) && err.code === 34) {
        return res.send(500, {
          error: "" + req.body.user + " is not a valid Twitter user"
        });
      } else if (err != null) {
        throw err;
      } else {
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
              return res.send(201, user);
            });
          } else {
            return res.send(500, {
              error: "" + req.body.user + " is already a user"
            });
          }
        });
      }
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
        if (req.user.userid === req.params.id) {
          req.session.destroy();
          return res.send(200, results);
        } else {
          return res.send(200, results);
        }
      }
    });
  }
};
