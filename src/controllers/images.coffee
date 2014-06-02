path = require 'path'
_ = require 'lodash'
helpers = require path.join('..', 'helpers')
Image = require path.join('..', 'models', 'image')

errors =
  noIdError: "Please specify image type (pass/fail) in request url"
  noImageError: "No image found"
  noImageUrlSent: "No image url sent"
  needToLogin: "Action requires user to be logged in"

# image model's CRUD controller.
module.exports =

  # lists all images
  index: (req, res) ->
    Image.find {deleted: false}, (err, results) ->
      res.send 500, error: err if err?
      res.send results

  # displays single image
  show: (req, res) ->
    Image.findById req.params.id, (err, result) ->
      res.send 500, error: err if err?
      res.send result

  # returns random image url based on id of pass/fail
  random: (req, res) ->
    if !req.params.id? or !req.params.id.match /(pass|fail)/g
      res.send 500, error: errors.noIdError
    Image.find
      kind: req.params.id
      deleted: false
    , 'image_url', (err, results) ->
      res.send 500, error: err if err?
      randomImage = _.sample(results)
      unless !randomImage?
        res.send(randomImage.image_url)
      else
        res.send 500, error: errors.noImageError

  # creates new image record
  create: (req, res)  ->
    if helpers.checkForUser req, res
      # should validate url here
      url = req.body.source_url
      if url is undefined or url == ''
        res.send 500, error: errors.noImageUrlSent
      else
        req.body.added_by = req.user.userid
        if url.match /imgur.com/
          req.body.image_url = url
          img = new Image(req.body)
          img.save (err, results) ->
            res.send 500, error: err if err?
            res.send(results)
        else
          console.log 'get imgur url'

    else
      res.send 500, error: needToLogin

  # updates existing image record type: pass or fail
  update: (req, res) ->
    if helpers.checkForUser req, res
      updateData =
        kind: req.body.kind
        updated_by: req.user.userid
      Image.update {_id: req.params.id}, updateData, (err, count) ->
        res.send 500, error: err if err?
        res.send 200, success: "#{count} rows have been updated"
    else
      res.send 500, error: needToLogin

  # deletes image record non-permanently
  delete: (req, res) ->
    if helpers.checkForUser req, res
      updateData =
        deleted: true
        deleted_by: req.user.userid
      Image.update {_id: req.params.id}, updateData, (err, count) ->
        res.send 500, error: err if err?
        res.send 200, success: "#{count} rows have been deleted"
    else
      res.send 500, error: needToLogin
