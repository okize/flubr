# modules
path = require 'path'
express = require 'express'
logger = require 'morgan'
session = require 'express-session'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
livereload = require 'connect-livereload'
mongoose = require 'mongoose'
coffee = require 'coffee-script'
coffeescriptMiddleware = require 'connect-coffee-script'
stylus = require 'stylus'
nib = require 'nib'

# create application instance
app = express()

# configuration
app.set 'app name', 'Blundercats'
app.set 'env', process.env.NODE_ENV or 'development'
app.set 'port', process.env.PORT or 2000
app.set 'views', path.join(__dirname, '..', 'views')
app.set 'view engine', 'jade'
app.set 'db-url', process.env.MONGOHQ_URL or 'mongodb://localhost/images'

# database connection
mongoose.connect app.get('db-url'), {db: {safe: true}}, (err) ->
  unless err?
    console.log 'Mongoose - connection OK'
  else
    console.log 'Mongoose - connection error: ' + err if err?

# dev middleware
if app.get('env') == 'development'
  app.use livereload()

# middleware
app.use stylus.middleware
  src: path.join(__dirname, '..', 'views')
  dest: path.join(__dirname, '..', 'public')
  debug: true
  compile: (str, _path) ->
    stylus(str)
      .set('filename', _path)
      .set('compress', true)
      .use(nib())
      .import('nib')
app.use coffeescriptMiddleware
  src: path.join(__dirname, '..', 'views')
  dest: path.join(__dirname, '..', 'public')
  bare: true
  compress: true
app.use logger('dev')

# assets
app.use express.static(path.join(__dirname, '..', 'public'))

# sessions
console.log 'Setting session/cookie'
app.use cookieParser()
app.use session(
  secret: 'blundercats'
  key: 'sid'
  cookie:
    secure: true
)

# parses json & xml
app.use bodyParser()

# routes
routes = require './routes'
routes(app)

app.listen app.get('port'), ->
  console.log "#{app.get('app name')} running on port #{app.get('port')}"
