// modules
const path = require('path');
const fs = require('fs');
const pak = require('../package.json');
const express = require('express');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const session = require('express-session');
const Store = require('connect-mongostore')(session);
const logger = require('morgan');
const mongoose = require('mongoose');
const passport = require('passport');
const livereload = require('connect-livereload');
const coffee = require('coffee-script');
const coffeeify = require('coffeeify');
const browserify = require('browserify-middleware');
const stylus = require('stylus');
const nib = require('nib');
const routes = require('./routes');
const authentication = require('./authentication');
const favicon = require('serve-favicon');

// create application instance
const app = express();

// configuration
app.set('env', process.env.NODE_ENV || 'development');
app.set('port', process.env.PORT || 3333);
app.set('app name', 'Flubr');
app.set('app version', pak.version);
app.set('views', path.join(__dirname, '..', 'views'));
app.set('view engine', 'pug');

// dev/prod database location
if (app.get('env') === 'development') {
  app.set('db url', process.env.MONGODB_DEV_URL);
} else {
  app.set('db url', process.env.MONGOHQ_URL || process.env.MONGODB_PROD_URL);
}

// database connection
mongoose.connect(app.get('db url'), { db: { safe: true } }, (err) => {
  if (err == null) {
    return console.log('Mongoose - connection OK');
  } else if (err != null) { return console.log(`Mongoose - connection error: ${err}`); }
});

// js and css for development
if (app.get('env') === 'development') {
  // compiles stylus in memory
  app.route('/stylesheets/styles.css')
    .get((req, res, next) => {
      const css = stylus(fs.readFileSync('./views/stylesheets/styles.styl', 'utf8'))
              .set('filename', './views/stylesheets/')
              .set('paths', ['./views/stylesheets/'])
              .set('compress', false)
              .set('linenos', true)
              .use(nib())
              .render();
      res.set('Content-Type', 'text/css');
      return res.send(css);
    });

  // compiles coffeescript in memory with Browserify
  browserify.settings('transform', [coffeeify]);
  browserify.settings('debug', true);
  app.get('/javascripts/scripts.js', browserify('./views/javascripts/scripts.coffee', {
    extensions: ['.coffee'],
    cache: false,
    precompile: true,
  }));
}

// gzip assets
app.use(compression({ threshold: 1024 }));

// static assets
app.use(express.static(path.join(__dirname, '..', 'public'), { maxAge: 86400000 }));
app.use(favicon(path.join(__dirname, '..', 'public', 'images', 'favicon.ico')));

// insert livereload script into page in development
if (app.get('env') === 'development') {
  app.use(livereload({ port: process.env.LIVE_RELOAD_PORT || 35729 }));
}

// sessions
app.use(cookieParser(process.env.SECRET_TOKEN));
app.use(session({
  name: 'express_session',
  secret: process.env.SECRET_TOKEN,
  saveUninitialized: true,
  resave: true,
  store: new Store({
    mongooseConnection: mongoose.connections[0],
    collection: 'sessions',
  }),
}));

// passport config (see also authentication.coffee)
app.use(passport.initialize());
app.use(passport.session());

// parses json
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// logger
app.use(logger('dev'));

// routes
routes(app, passport);

// await connections
app.listen(app.get('port'), () => {
  console.log(`\n\nFlubr (v${pak.version}) in [${app.get('env')}] running @ http://localhost:${app.get('port')}\n\n`);
});
