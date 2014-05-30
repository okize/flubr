var Store, app, authentication, bodyParser, coffee, coffeescriptMiddleware, cookieParser, express, livereload, logger, mongoose, nib, passport, path, routes, session, stylus;

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

coffeescriptMiddleware = require('connect-coffee-script');

stylus = require('stylus');

nib = require('nib');

routes = require('./routes');

authentication = require('./authentication');

app = express();

app.set('env', process.env.NODE_ENV || 'development');

app.set('port', process.env.PORT || 3333);

app.set('host name', process.env.HOST_NAME);

app.set('app name', 'Blundercats');

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

app.set('db url', process.env.MONGODB_URL || 'mongodb://localhost/blundercats');

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
    port: 35730
  }));
}

app.use(stylus.middleware({
  src: path.join(__dirname, '..', 'views'),
  dest: path.join(__dirname, '..', 'public'),
  debug: true,
  compile: function(str, cssPath) {
    return stylus(str).set('filename', cssPath).set('compress', true).use(nib())["import"]('nib');
  }
}));

app.use(coffeescriptMiddleware({
  src: path.join(__dirname, '..', 'views'),
  dest: path.join(__dirname, '..', 'public'),
  bare: true,
  compress: true
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
