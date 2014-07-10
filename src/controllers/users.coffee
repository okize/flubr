path = require 'path'
Twit = require 'twit'
twitter = new Twit(
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
)
User = require path.join('..', 'models', 'user')
help = require path.join('..', 'helpers')

# user model's CRUD controller.
module.exports =

  # lists all users
  index: (req, res) ->
    User.find {}, (err, results) ->
      res.send 500, error: err if err?
      res.send 200, results

  # creates new user record
  # expects Twitter username in request body
  create: (req, res)  ->
    twitter.get('users/show', screen_name: req.body.user, (err, data) ->
      # https://dev.twitter.com/docs/error-codes-responses
      if err? && err.code == 34
        res.send(500, {error: "#{req.body.user} is not a valid Twitter user"})
      else if err?
        throw err
      else
        user = new User()
        user.userid = data.id
        user.userName = data.screen_name
        user.displayName = data.name
        user.avatar = data.profile_image_url

        # check if user already exists, save user if new
        User.find {userid: user.userid}, (err, results) ->
          throw err if err
          unless results.length
            user.save (err) ->
              res.send 500, error: err if err?
              res.send 201, user
          else
            res.send 500, {error: "#{req.body.user} is already a user"}
    )

  # updates existing user record
  update: (req, res) ->
    User.findByIdAndUpdate req.params.id, { $set: req.body }, (err, results) ->
      res.send 500, error: err if err?
      res.send results if results?

  # deletes user record
  delete: (req, res) ->
    User.findOneAndRemove {userid: req.params.id}, (err, results) ->
      res.send 500, error: err if err?
      if results?
        # user deletes themselves so delete session
        if req.user.userid == req.params.id
          req.session.destroy()
          res.send 200, results
        else
          res.send 200, results
