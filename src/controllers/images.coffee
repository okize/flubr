path = require 'path'
_ = require 'lodash'
help = require path.join('..', 'helpers')
Image = require path.join('..', 'models', 'image')
request = require 'request'
async = require 'async'

checkUrlIsImage = (url) ->
  url.match(/\.(jpeg|jpg|gif|png)$/) != null

errors =
  needToLogin: 'Action requires user to be authenticated'
  noIdError: 'Please specify image type (pass/fail) in request url'
  noImageError: 'No image found'
  noImageUrlSent: 'No image url specified'
  invalidImageUrl: 'That does not appear to be a valid image url'

# image model's CRUD controller.
module.exports =

  # lists all images
  index: (req, res) ->
    Image.find(deleted: false).sort(created_at: 'descending').exec(
      (err, results) ->
        res.send 500, error: err if err?
        res.send results
    )

  # lists all deleted images
  indexDeleted: (req, res) ->
    Image.find(deleted: true).sort(created_at: 'descending').exec(
      (err, results) ->
        res.send 500, error: err if err?
        res.send results
    )

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
    if help.checkForUser req, res

      url = req.body.source_url

      if url is undefined or url == ''
        res.send 422, error: errors.noImageUrlSent
      else if !checkUrlIsImage url
        res.send 422, error: errors.invalidImageUrl
      else
        async.series [
          (callback) ->

            unless url.match /imgur.com/
              data =
                image: url
                type: 'url'
              options =
                url: 'https://api.imgur.com/3/image'
                headers:
                  Authorization: "Client-ID #{process.env.IMGUR_CLIENTID}"
                  'Content-Type': 'application/x-www-form-urlencoded'
                  Accept: 'application/json'

              request.post(options,
                (err, response, body) ->
                  callback err, null if err
                  data = JSON.parse(body)
                  if !data.success
                    callback data.data.error, null
                    # res.send 500, error: err if err?
                  else
                    callback null, data.data.link
              ).form(data)

            else
              callback null, url

        ], (err, results) ->
          if err?
            res.send 500, error: err
          else
            req.body.added_by = req.user.userid
            req.body.image_url = results[0]
            img = new Image(req.body)
            img.save (err, results) ->
              res.send 500, error: err if err?
              res.send(results)

    else
      res.send 500, error: needToLogin

  # updates existing image record type: pass or fail
  update: (req, res) ->
    if help.checkForUser req, res
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
    if help.checkForUser req, res
      updateData =
        deleted: true
        deleted_by: req.user.userid
      Image.update {_id: req.params.id}, updateData, (err, count) ->
        res.send 500, error: err if err?
        res.send 200, success: "#{count} rows have been deleted"
    else
      res.send 500, error: needToLogin
