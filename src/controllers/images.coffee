path = require 'path'
_ = require 'lodash'
Image = require path.join('..', 'models', 'image')

errors =
  noIdError: "Please specify image type (pass/fail) in request url"
  noImageError: "No image found"

# image model's CRUD controller.
module.exports =

  # lists all images
  index: (req, res) ->
    Image.find {}, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send results

  # displays single image
  show: (req, res) ->
    Image.find {_id: req.params.id}, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send results

  # returns random image url based on id of pass/fail
  random: (req, res) ->
    res.send 500, error: errors.noIdError if !req.params.id? or !req.params.id.match /(pass|fail)/g
    Image.find {kind: req.params.id}, 'image_url', (err, results) ->
      res.send(500, { error: err }) if err?
      randomImage = _.sample(results)
      unless !randomImage?
        res.send(randomImage.image_url)
      else
        res.send 500, error: errors.noImageError

  # creates new image record
  create: (req, res)  ->
    img = new Image(req.body)
    img.save (err, results) ->
      res.send(500, {error: err}) if err?
      res.send(results)

  # updates existing image record
  update: (req, res) ->
    Image.findByIdAndUpdate req.params.id, { $set: req.body }, (err, results) ->
      res.send(500, { error: err}) if err?
      res.send(results) if results?
      res.send(404)

  # deletes image record
  delete: (req, res) ->
    Image.findByIdAndRemove req.params.id, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send(200, results) if results?
      res.send(404)