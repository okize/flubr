express = require 'express'
mongoose = require 'mongoose'
images = require './controller/images'
home = require './routes/index'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

app = express()

app.set 'port', process.env.PORT or 3000

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.set 'storage-uri', process.env.MONGOHQ_URL or 'mongodb://localhost/images'
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static(path.join(__dirname, '..', 'public'))

app.use '/', home

mongoose.connect app.get('storage-uri'), {db: {safe: true}}, (err) ->
  console.log 'Mongoose - connection error: ' + err if err?
  console.log 'Mongoose - connection OK'

require './model/image'

app.post    '/images',     images.create
app.get     '/images',     images.retrieve
app.get     '/images/:type', images.retrieve
# app.put     '/images/:id', images.update
# app.delete  '/images/:id', images.delete

app.listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"