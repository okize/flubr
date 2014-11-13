# modules
path = require 'path'
fs = require 'fs'
pak = require '../package.json'
express = require 'express'
compression = require 'compression'
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
coffeeify = require 'coffeeify'
browserify = require 'browserify-middleware'
stylus = require 'stylus'
nib = require 'nib'
routes = require './routes'
authentication = require './authentication'
favicon = require 'serve-favicon'

# create application instance
app = express()

# configuration
app.set 'env', process.env.NODE_ENV or 'development'
app.set 'port', process.env.PORT or 3333
app.set 'app name', 'Flubr'
app.set 'app version', pak.version
app.set 'views', path.join(__dirname, '..', 'views')
app.set 'view engine', 'jade'

# dev/prod database location
if app.get('env') == 'development'
  app.set 'db url', process.env.MONGODB_DEV_URL
else
  app.set 'db url', process.env.MONGOHQ_URL or process.env.MONGODB_PROD_URL

# database connection
mongoose.connect app.get('db url'), {db: {safe: true}}, (err) ->
  unless err?
    console.log 'Mongoose - connection OK'
  else
    console.log 'Mongoose - connection error: ' + err if err?

# js and css for development
if app.get('env') == 'development'

  # compiles stylus in memory
  app.route('/stylesheets/styles.css')
    .get (req, res, next) ->
      css = stylus(fs.readFileSync('./views/stylesheets/styles.styl', 'utf8'))
              .set('filename', './views/stylesheets/')
              .set('paths', ['./views/stylesheets/'])
              .set('compress', false)
              .set('linenos', true)
              .use(nib())
              .render()
      res.set 'Content-Type', 'text/css'
      res.send css

  # compiles coffeescript in memory with Browserify
  browserify.settings 'transform', [coffeeify]
  browserify.settings 'debug', true
  app.get '/javascripts/scripts.js',
    browserify('./views/javascripts/scripts.coffee',
      extensions: ['.coffee']
      cache: false
      precompile: true
    )

# gzip assets
app.use compression(threshold: 1024)

# static assets
app.use express.static(path.join(__dirname, '..', 'public'), maxAge: 86400000)
app.use favicon(path.join __dirname, '..', 'public', 'images', 'favicon.ico')

# insert livereload script into page in development
if app.get('env') == 'development'
  app.use livereload(port: process.env.LIVE_RELOAD_PORT or 35729)

# sessions
app.use cookieParser(process.env.SECRET_TOKEN)
app.use session(
  name: 'express_session'
  secret: process.env.SECRET_TOKEN
  saveUninitialized: true
  resave: true
  store: new Store(
    mongooseConnection: mongoose.connections[0]
    collection: 'sessions'
  )
)

# passport config (see also authentication.coffee)
app.use passport.initialize()
app.use passport.session()

# parses json
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)

# logger
app.use logger('dev')

# routes
routes(app, passport)

# await connections
app.listen app.get('port'), ->
  console.log "#{app.get('app name')} (#{app.get('app version')}) " +
              "running on port #{app.get('port')} in [#{app.get('env')}]"
