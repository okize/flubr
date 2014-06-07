# modules
path = require 'path'
express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
Store = require('connect-mongostore')(session)
logger = require 'morgan'
mongoose = require 'mongoose'
passport = require 'passport'
livereload = require 'connect-livereload'
mongoose = require 'mongoose'
coffee = require 'coffee-script'
coffeescriptMiddleware = require 'connect-coffee-script'
stylus = require 'stylus'
axis = require 'axis-css'
nib = require 'nib'
routes = require './routes'
authentication = require './authentication'

# create application instance
app = express()

# configuration
app.set 'env', process.env.NODE_ENV or 'development'
app.set 'port', process.env.PORT or 3333
app.set 'app name', 'Passfail'
app.set 'host name', process.env.HOST_NAME
app.set 'views', path.join(__dirname, '..', 'views')
app.set 'view engine', 'jade'
app.set 'db url', process.env.MONGODB_URL or 'mongodb://localhost/passfail'

# database connection
mongoose.connect app.get('db url'), {db: {safe: true}}, (err) ->
  unless err?
    console.log 'Mongoose - connection OK'
  else
    console.log 'Mongoose - connection error: ' + err if err?

# dev middleware
if app.get('env') == 'development'
  app.use livereload( port: 35730 )

# assets middleware
app.use stylus.middleware
  src: path.join(__dirname, '..', 'views')
  dest: path.join(__dirname, '..', 'public')
  debug: true
  compile: (str, cssPath) ->
    stylus(str)
      .set('filename', cssPath)
      .set('compress', false)
      .use(axis(implicit: false))
app.use coffeescriptMiddleware
  src: path.join(__dirname, '..', 'views')
  dest: path.join(__dirname, '..', 'public')
  bare: true
  compress: true
app.use express.static(path.join(__dirname, '..', 'public'))

app.use cookieParser('blundercats')
app.use bodyParser()

# sessions
app.use session(
  name: 'express_session'
  secret: 'blundercats'
  store: new Store(
    mongooseConnection: mongoose.connections[0]
    collection: 'sessions'
  )
)

# passport config (see also authentication.coffee)
app.use passport.initialize()
app.use passport.session()

# parses json & xml
app.use bodyParser()

# logger
app.use logger('dev')

# routes
routes(app, passport)

# await connections
app.listen app.get('port'), ->
  console.log "#{app.get('app name')} running on port #{app.get('port')}"
