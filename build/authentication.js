var User, allowedUsers, mongoose, passport, passportTwitterStrategy, _;

_ = require('lodash');

mongoose = require('mongoose');

passport = require('passport');

passportTwitterStrategy = require('passport-twitter').Strategy;

User = require('./models/user');

allowedUsers = process.env.ALLOWED_USERS.split(',');

passport.serializeUser(function(user, done) {
  console.log("serializeUser: " + user.userName);
  return done(null, user._id);
});

passport.deserializeUser(function(id, done) {
  return User.findById(id, function(err, user) {
    console.log("deserializeUser: " + user.userName);
    if (!err) {
      return done(null, user);
    } else {
      return done(err, null);
    }
  });
});

module.exports = passport.use(new passportTwitterStrategy({
  consumerKey: process.env.TWITTER_CONSUMER_KEY,
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET,
  callbackURL: '/auth/callback'
}, function(token, tokenSecret, profile, done) {
  if (_.contains(allowedUsers, profile.id)) {
    return User.findOne({
      userid: profile.id
    }, function(err, user) {
      if (user) {
        return done(null, user);
      } else {
        console.log("Created new user account for " + profile.username);
        user = new User();
        user.userid = profile.id;
        user.userName = profile.username;
        user.displayName = profile.displayName;
        user.avatar = profile._json.profile_image_url;
        return user.save(function(err) {
          if (err) {
            throw err;
          }
          return done(null, user);
        });
      }
    });
  } else {
    throw new Error('User not allowed');
  }
}));
