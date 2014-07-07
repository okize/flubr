passport = require 'passport'
passportTwitterStrategy = require('passport-twitter').Strategy
User = require './models/user'

# passport session setup
passport.serializeUser (user, done) ->
  console.log "Serialized user: #{user.userName}"
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    unless err
      done null, user
    else
      done err, null

# passport authentication configuration
module.exports = passport.use new passportTwitterStrategy(
  consumerKey: process.env.TWITTER_CONSUMER_KEY
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET
  callbackURL: '/auth'
, (token, tokenSecret, profile, done) ->

  # make sure user is in list of allowed users
  User.findOne
    userid: profile.id
  , (err, user) ->
    done err if err
    if user
      done null, user
    else
      done 'You are not authorized to use this application', null
)