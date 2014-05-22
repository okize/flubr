var app, bodyParser, coffee, coffeescriptMiddleware, cookieParser, express, livereload, logger, mongoose, nib, path, routes, session, stylus;

path = require('path');

express = require('express');

logger = require('morgan');

session = require('express-session');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

livereload = require('connect-livereload');

mongoose = require('mongoose');

coffee = require('coffee-script');

coffeescriptMiddleware = require('connect-coffee-script');

stylus = require('stylus');

nib = require('nib');

app = express();

app.set('app name', 'Blundercats');

app.set('env', process.env.NODE_ENV || 'development');

app.set('port', process.env.PORT || 2000);

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

app.set('db-url', process.env.MONGOHQ_URL || 'mongodb://localhost/images');

mongoose.connect(app.get('db-url'), {
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
  app.use(livereload());
}

app.use(stylus.middleware({
  src: path.join(__dirname, '..', 'views'),
  dest: path.join(__dirname, '..', 'public'),
  debug: true,
  compile: function(str, _path) {
    return stylus(str).set('filename', _path).set('compress', true).use(nib())["import"]('nib');
  }
}));

app.use(coffeescriptMiddleware({
  src: path.join(__dirname, '..', 'views'),
  dest: path.join(__dirname, '..', 'public'),
  bare: true,
  compress: true
}));

app.use(logger('dev'));

app.use(express["static"](path.join(__dirname, '..', 'public')));

console.log('Setting session/cookie');

app.use(cookieParser());

app.use(session({
  secret: 'blundercats',
  key: 'sid',
  cookie: {
    secure: true
  }
}));

app.use(bodyParser());

routes = require('./routes');

routes(app);

app.listen(app.get('port'), function() {
  return console.log("" + (app.get('app name')) + " running on port " + (app.get('port')));
});
