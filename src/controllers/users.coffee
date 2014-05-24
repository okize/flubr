path = require 'path'
User = require path.join('..', 'models', 'user')

# user model's CRUD controller.
module.exports =

  # lists all users
  index: (req, res) ->
    User.find {}, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send results

  # creates new user record
  create: (req, res)  ->
    img = new User(req.body)
    img.save (err, results) ->
      res.send(500, {error: err}) if err?
      res.send(results)

  # updates existing user record
  update: (req, res) ->
    User.findByIdAndUpdate req.params.id, { $set: req.body }, (err, results) ->
      res.send(500, { error: err}) if err?
      res.send(results) if results?
      res.send(404)

  # deletes user record
  delete: (req, res) ->
    User.findByIdAndRemove req.params.id, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send(200, results) if results?
      res.send(404)