_ = require 'lodash'
mongoose = require 'mongoose'
passport = require 'passport'
passportTwitterStrategy = require('passport-twitter').Strategy
User = require './models/user'
allowedUsers = process.env.ALLOWED_USERS.split ','

# passport session setup
passport.serializeUser (user, done) ->
  console.log "serializeUser: #{user.userName}"
  done null, user._id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    console.log "deserializeUser: #{user.userName}"
    unless err
      done null, user
    else
      done err, null

# passport authentication configuration
passport.use new passportTwitterStrategy(
  consumerKey: process.env.TWITTER_CONSUMER_KEY
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET
  callbackURL: '/auth/callback'
, (token, tokenSecret, profile, done) ->

  # make sure user is in list of allowed users
  if _.contains(allowedUsers, profile.id)
    User.findOne
      userid: profile.id
    , (err, user) ->
      if user
        done null, user
      else
        console.log "Created new user account for #{profile.username}"
        user = new User()
        user.userid = profile.id
        user.userName = profile.username
        user.displayName = profile.displayName
        user.avatar = profile._json.profile_image_url
        user.save (err) ->
          throw err if err
          done null, user
  else
    throw new Error 'User not allowed'
)