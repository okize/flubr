const passport = require('passport');
const passportTwitterStrategy = require('passport-twitter').Strategy;
const User = require('./models/user');

// passport session setup
passport.serializeUser(function(user, done) {
  console.log(`Serialized user: ${user.userName}`);
  return done(null, user.id);
});

passport.deserializeUser((id, done) =>
  User.findById(id, function(err, user) {
    if (!err) {
      return done(null, user);
    } else {
      return done(err, null);
    }
  })
);

// passport authentication configuration
module.exports = passport.use(new passportTwitterStrategy({
  consumerKey: process.env.TWITTER_CONSUMER_KEY,
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET,
  callbackURL: '/auth'
}
, function(token, tokenSecret, profile, done) {

  // make sure user is in list of allowed users
  return User.findOne(
    {userid: profile.id}
  , function(err, user) {
    if (err) {
      done(err);
    }
    if (user) {
      return done(null, user);
    } else {
      return done(null, null);
    }
});
})
);