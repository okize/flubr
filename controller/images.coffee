mongoose = require 'mongoose'

exports.create = (req, res)  ->
  Resource = mongoose.model('Image')
  fields = req.body

  r = new Resource(fields)
  r.save (err, resource) ->
    res.send(500, {error: err}) if err?
    res.send(resource)


exports.retrieve = (req, res) ->
  Resource = mongoose.model('Image')

  if req.params.type?
    Resource.findRandom (err, resource) ->
      res.send(500, { error: err }) if err?
      res.send(resource.image_url) if resource?
  else
    Resource.find {}, (err, coll) ->
      res.send(500, { error: err }) if err?
      res.send(coll)


# exports.retrieve = (req, res) ->
#   Resource = mongoose.model('Image')

#   if req.params.id?
#     Resource.findById req.params.id, (err, resource) ->
#       res.send(500, { error: err }) if err?
#       res.send(resource) if resource?
#       res.send(404)
#   else
#     Resource.find {}, (err, coll) ->
#       res.send(coll)




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