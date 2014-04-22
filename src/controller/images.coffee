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
      res.json(randomImage) if randomImage?
  else
    Resource.find {}, (err, coll) ->
      res.send(500, { error: err }) if err?
      res.send(coll)



# exports.update = (req, res) ->
#   Resource = mongoose.model('Image')
#   fields - req.body

#   Resource.findByIdAndUpdate req.params.id, { $set: fields }, (err, resource) ->
#     res.send(500, { error: err}) if err?
#     res.send(resource) if resource?
#     res.send(404)


# exports.delete = (req, res) ->
#   Resource = mongoose.model('Image')

#   Resource.findByIdAndRemove req.params.id, (err, resource) ->
#     res.send(500, {error: err}) if err?
#     res.send(200) if resource?
#     res.send(404)