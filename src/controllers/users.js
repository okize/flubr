const path = require('path');
const Twit = require('twit');
const twitter = new Twit({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token: process.env.TWITTER_ACCESS_TOKEN,
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET,
});
const User = require(path.join('..', 'models', 'user'));
const help = require(path.join('..', 'helpers'));

// user model's CRUD controller.
module.exports = {

  // lists all users
  index(req, res) {
    return User.find({}, (err, results) => {
      if (err != null) { res.send(500, { error: err }); }
      return res.send(200, results);
    });
  },

  // creates new user record
  // expects Twitter username in request body
  create(req, res) {
    return twitter.get('users/show', { screen_name: req.body.user }, (err, data) => {
      // https://dev.twitter.com/docs/error-codes-responses
      if ((err != null) && (err.code === 34)) {
        return res.send(500, { error: `${req.body.user} is not a valid Twitter user` });
      } else if (err != null) {
        throw err;
      } else {
        const user = new User();
        user.userid = data.id;
        user.userName = data.screen_name;
        user.displayName = data.name;
        user.avatar = data.profile_image_url;

        // check if user already exists, save user if new
        return User.find({ userid: user.userid }, (err, results) => {
          if (err) { throw err; }
          if (!results.length) {
            return user.save((err) => {
              if (err != null) { res.send(500, { error: err }); }

              // if saved user was first user redirect to login
              if (req.body.firstUser != null) {
                return res.redirect('/login');
              }
              return res.send(201, user);
            });
          }
          return res.send(500, { error: `${req.body.user} is already a user` });
        });
      }
    });
  },

  // updates existing user record
  update(req, res) {
    return User.findByIdAndUpdate(req.params.id, { $set: req.body }, (err, results) => {
      if (err != null) { res.send(500, { error: err }); }
      if (results != null) { return res.send(results); }
    });
  },

  // deletes user record
  delete(req, res) {
    return User.findOneAndRemove({ userid: req.params.id }, (err, results) => {
      if (err != null) { res.send(500, { error: err }); }
      if (results != null) {
        // user deletes themselves so delete session
        if (req.user.userid === req.params.id) {
          req.session.destroy();
          return res.send(200, results);
        }
        return res.send(200, results);
      }
    });
  },
};
