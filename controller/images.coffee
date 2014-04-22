mongoose = require 'mongoose'
_ = require 'lodash'

exports.create = (req, res)  ->
  Resource = mongoose.model('Image')
  fields = req.body

  r = new Resource(fields)
  r.save (err, resource) ->
    res.send(500, {error: err}) if err?
    res.send(resource)

exports.retrieve = (req, res) ->
  Resource = mongoose.model('Image')

  # if url has fail/win then return a random win or fail url
  if req.params.type?
    Resource.find {kind: req.params.type}, 'image_url randomizer', (err, resource) ->
      randomImage = _.sample(resource)
      res.send(500, { error: err }) if err?
      res.send(randomImage.image_url) if resource?
  else
    Resource.find {}, (err, coll) ->
      res.send(500, { error: err }) if err?
      res.send(coll)
