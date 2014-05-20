path = require 'path'
_ = require 'lodash'
Image = require path.join('..', 'models', 'image')

errors =
  noIdError: "Please specify image type (pass/fail) in request url"

# image model's CRUD controller.
module.exports =

  # lists all images
  index: (req, res) ->
    Image.find {}, (err, results) ->
      res.send(500, {error: err}) if err?
      res.send results

  # returns random image url based on id of pass/fail
  random: (req, res) ->
    res.send 500, error: errors.noIdError if !req.params.id? or !req.params.id.match /(pass|fail)/g
    Image.find {kind: req.params.id}, 'image_url randomizer', (err, results) ->
      res.send(500, { error: err }) if err?
      randomImage = _.sample(results)
      res.send(randomImage.image_url) if randomImage?
