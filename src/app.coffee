# modules
path = require 'path'
fs = require 'fs'
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
coffeeify = require "coffeeify"
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
  app.use livereload(port: process.env.LIVE_RELOAD_PORT or 35730)
  app.route('/stylesheets/styles.css')
    .get (req, res, next) ->
      css = stylus(fs.readFileSync('./views/stylesheets/styles.styl', 'utf8'))
              .set('compress', false)
              .set('linenos', true)
              .use(axis(implicit: false))
              .render()
      res.set 'Content-Type', 'text/css'
      res.send css
  browserify.settings 'transform', [coffeeify]
  app.get '/javascripts/scripts.js',
    browserify('./views/javascripts/scripts.coffee',
      extensions: ['.coffee']
      cache: false
      precompile: true
    )

# static assets
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
  console.log "#{app.get('app name')} running on port #{app.get('port')} " +
              "in [#{app.get('env')}]"