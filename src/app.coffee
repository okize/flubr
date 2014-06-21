# modules
path = require 'path'
fs = require 'fs'
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
axis = require 'axis-css'
routes = require './routes'
authentication = require './authentication'

# create application instance
app = express()

# configuration
app.set 'env', process.env.NODE_ENV or 'development'
app.set 'port', process.env.PORT or 3333
app.set 'app name', 'Flubr'
app.set 'views', path.join(__dirname, '..', 'views')
app.set 'view engine', 'jade'
app.set 'db url', process.env.MONGODB_URL or 'mongodb://localhost/flubr'

# database connection
mongoose.connect app.get('db url'), {db: {safe: true}}, (err) ->
  unless err?
    console.log 'Mongoose - connection OK'
  else
    console.log 'Mongoose - connection error: ' + err if err?

# dev middleware
if app.get('env') == 'development'

  # insert livereload script into page
  app.use livereload(port: process.env.LIVE_RELOAD_PORT or 35730)

  # compiles stylus in memory
  app.route('/stylesheets/styles.css')
    .get (req, res, next) ->
      css = stylus(fs.readFileSync('./views/stylesheets/styles.styl', 'utf8'))
              .set('filename', './views/stylesheets/')
              .set('paths', ['./views/stylesheets/'])
              .set('compress', false)
              .set('linenos', true)
              .use(axis(implicit: false))
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
app.use express.static(path.join(__dirname, '..', 'public'))

# sessions
app.use cookieParser(process.env.SESSION_SECRET)
app.use bodyParser()
app.use session(
  name: 'express_session'
  secret: process.env.SESSION_SECRET
  store: new Store(
    mongooseConnection: mongoose.connections[0]
    collection: 'sessions'
  )
)

# passport config (see also authentication.coffee)
app.use passport.initialize()
app.use passport.session()

# parses json & xml
app.use(bodyParser.urlencoded(extended: true))
app.use(bodyParser.json())

# logger
app.use logger('dev')

# routes
routes(app, passport)

# await connections
app.listen app.get('port'), ->
  console.log "#{app.get('app name')} running on port #{app.get('port')} " +
              "in [#{app.get('env')}]"