# modules
path = require 'path'
express = require 'express'
cookieParser = require 'cookie-parser'
session = require 'express-session'
logger = require 'morgan'
mongoose = require 'mongoose'
passport = require 'passport'
bodyParser = require 'body-parser'
livereload = require 'connect-livereload'
mongoose = require 'mongoose'
coffee = require 'coffee-script'
coffeescriptMiddleware = require 'connect-coffee-script'
stylus = require 'stylus'
nib = require 'nib'
routes = require './routes'
authentication = require './authentication'

# create application instance
app = express()

# configuration
app.set 'env', process.env.NODE_ENV or 'development'
app.set 'port', process.env.PORT or 3333
app.set 'host name', process.env.HOST_NAME
app.set 'app name', 'Blundercats'
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
  compile: (str, cssPath) ->
    stylus(str)
      .set('filename', cssPath)
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
app.use bodyParser()
app.use session(
  secret: 'blundercats'
  key: 'sid'
)

# passport config (see also authentication.coffee)
app.use passport.initialize()
app.use passport.session()

# parses json & xml
app.use bodyParser()

# routes
routes(app, passport)

# await connections
app.listen app.get('port'), ->
  console.log "#{app.get('app name')} running on port #{app.get('port')}"
