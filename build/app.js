var Store, app, authentication, axis, bodyParser, browserify, coffee, coffeeify, cookieParser, express, livereload, logger, mongoose, passport, path, routes, session, stylus;

path = require('path');

express = require('express');

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

coffeeify = require("coffeeify");

browserify = require('browserify-middleware');

stylus = require('stylus');

axis = require('axis-css');

routes = require('./routes');

authentication = require('./authentication');

app = express();

app.set('env', process.env.NODE_ENV || 'development');

app.set('port', process.env.PORT || 3333);

app.set('app name', 'Flubr');

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

app.set('db url', process.env.MONGODB_URL || 'mongodb://localhost/flubr');

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
  app.use(livereload({
    port: process.env.LIVE_RELOAD_PORT || 35729
  }));
}

browserify.settings('transform', [coffeeify]);

app.use(stylus.middleware({
  src: path.join(__dirname, '..', 'views'),
  dest: path.join(__dirname, '..', 'public'),
  debug: true,
  compile: function(str, cssPath) {
    return stylus(str).set('filename', cssPath).set('compress', false).set('linenos', true).use(axis({
      implicit: false
    }));
  }
}));

app.get('/javascripts/scripts.js', browserify('./views/javascripts/scripts.coffee', {
  cache: false,
  precompile: true
}));

app.use(express["static"](path.join(__dirname, '..', 'public')));

app.use(cookieParser('blundercats'));

app.use(bodyParser());

app.use(session({
  name: 'express_session',
  secret: 'blundercats',
  store: new Store({
    mongooseConnection: mongoose.connections[0],
    collection: 'sessions'
  })
}));

app.use(passport.initialize());

app.use(passport.session());

app.use(bodyParser());

app.use(logger('dev'));

routes(app, passport);

app.listen(app.get('port'), function() {
  return console.log("" + (app.get('app name')) + " running on port " + (app.get('port')));
});
