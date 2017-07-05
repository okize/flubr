const passport = require('passport');
const PassportTwitterStrategy = require('passport-twitter').Strategy;
const User = require('./models/user');

// passport session setup
passport.serializeUser((user, done) => {
  console.log(`Serialized user: ${user.userName}`);
  return done(null, user.id);
});

passport.deserializeUser((id, done) => {
  User.findById(id, (err, user) => {
    if (!err) {
      return done(null, user);
    }
    return done(err, null);
  });
});

// passport authentication configuration
const passportConfig = {
  consumerKey: process.env.TWITTER_CONSUMER_KEY,
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET,
  callbackURL: '/auth',
};

module.exports = passport.use(new PassportTwitterStrategy(passportConfig, (token, tokenSecret, profile, done) => {
  // make sure user is in list of allowed users
  User.findOne({ userid: profile.id }, (err, user) => {
    if (err) { return done(err); }
    if (user) { return done(null, user); }
    return done(null, null);
  });
}));
