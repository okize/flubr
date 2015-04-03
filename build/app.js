var Store, app, authentication, bodyParser, browserify, coffee, coffeeify, compression, cookieParser, express, favicon, fs, livereload, logger, mongoose, nib, pak, passport, path, routes, session, stylus;

path = require('path');

fs = require('fs');

pak = require('../package.json');

express = require('express');

compression = require('compression');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

session = require('express-session');

Store = require('connect-mongostore')(session);

logger = require('morgan');

mongoose = require('mongoose');

passport = require('passport');

livereload = require('connect-livereload');

mongoose = require('mongoose');

coffee = require('coffee-script');

coffeeify = require('coffeeify');

browserify = require('browserify-middleware');

stylus = require('stylus');

nib = require('nib');

routes = require('./routes');

authentication = require('./authentication');

favicon = require('serve-favicon');

app = express();

app.set('env', process.env.NODE_ENV || 'development');

app.set('port', process.env.PORT || 3333);

app.set('app name', 'Flubr');

app.set('app version', pak.version);

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

if (app.get('env') === 'development') {
  app.set('db url', process.env.MONGODB_DEV_URL);
} else {
  app.set('db url', process.env.MONGOHQ_URL || process.env.MONGODB_PROD_URL);
}

mongoose.connect(app.get('db url'), {
  db: {
    safe: true
  }
}, function(err) {
  if (err == null) {
    return console.log('Mongoose - connection OK');
  } else {
    if (err != null) {
      return console.log('Mongoose - connection error: ' + err);
    }
  }
});

if (app.get('env') === 'development') {
  app.route('/stylesheets/styles.css').get(function(req, res, next) {
    var css;
    css = stylus(fs.readFileSync('./views/stylesheets/styles.styl', 'utf8')).set('filename', './views/stylesheets/').set('paths', ['./views/stylesheets/']).set('compress', false).set('linenos', true).use(nib()).render();
    res.set('Content-Type', 'text/css');
    return res.send(css);
  });
  browserify.settings('transform', [coffeeify]);
  browserify.settings('debug', true);
  app.get('/javascripts/scripts.js', browserify('./views/javascripts/scripts.coffee', {
    extensions: ['.coffee'],
    cache: false,
    precompile: true
  }));
}

app.use(compression({
  threshold: 1024
}));

app.use(express["static"](path.join(__dirname, '..', 'public'), {
  maxAge: 86400000
}));

app.use(favicon(path.join(__dirname, '..', 'public', 'images', 'favicon.ico')));

if (app.get('env') === 'development') {
  app.use(livereload({
    port: process.env.LIVE_RELOAD_PORT || 35729
  }));
}

app.use(cookieParser(process.env.SECRET_TOKEN));

app.use(session({
  name: 'express_session',
  secret: process.env.SECRET_TOKEN,
  saveUninitialized: true,
  resave: true,
  store: new Store({
    mongooseConnection: mongoose.connections[0],
    collection: 'sessions'
  })
}));

app.use(passport.initialize());

app.use(passport.session());

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: true
}));

app.use(logger('dev'));

routes(app, passport);

app.listen(app.get('port'), function() {
  return console.log(("\n\n" + (app.get('app name')) + " (" + (app.get('app version')) + ") ") + ("in [" + (app.get('env')) + "] ") + ("running on http://localhost:" + (app.get('port')) + " \n\n"));
});
