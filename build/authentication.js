var User, passport, passportTwitterStrategy;

passport = require('passport');

passportTwitterStrategy = require('passport-twitter').Strategy;

User = require('./models/user');

passport.serializeUser(function(user, done) {
  console.log("Serialized user: " + user.userName);
  return done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  return User.findById(id, function(err, user) {
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
  callbackURL: '/auth'
}, function(token, tokenSecret, profile, done) {
  return User.findOne({
    userid: profile.id
  }, function(err, user) {
    if (err) {
      done(err);
    }
    if (user) {
      return done(null, user);
    } else {
      return done(null, null);
    }
  });
}));
