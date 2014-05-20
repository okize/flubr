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

