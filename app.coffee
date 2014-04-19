express = require 'express'
mongoose = require 'mongoose'
images = require './controller/images'

app = express()

app.configure ->
  app.set 'port', process.env.PORT or 3000
  app.set 'storage-uri', process.env.MONGOHQ_URL or 'mongodb://localhost/images'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.methodOverride()

mongoose.connect app.get('storage-uri'), {db: {safe: true}}, (err) ->
  console.log 'Mongoose - connection error: ' + err if err?
  console.log 'Mongoose - connection OK'

require './model/image'

app.get '/', (req, res) ->
  res.send 'Blundercats!'

app.post    '/images',     images.create
app.get     '/images',     images.retrieve
app.get     '/images/:type', images.retrieve
# app.put     '/images/:id', images.update
# app.delete  '/images/:id', images.delete

app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"