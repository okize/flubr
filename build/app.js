var app, bodyParser, coffee, coffeescriptMiddleware, cookieParser, express, images, livereload, logger, methodOverride, mongoose, nib, path, stylus;

path = require('path');

express = require('express');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

methodOverride = require('method-override');

livereload = require('connect-livereload');

mongoose = require('mongoose');

coffee = require('coffee-script');

coffeescriptMiddleware = require('connect-coffee-script');

stylus = require('stylus');

nib = require('nib');

images = require('./controller/images');

app = express();

app.set('app name', 'Blundercats');

app.set('env', process.env.NODE_ENV || 'development');

app.set('port', process.env.PORT || 2000);

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

app.set('db-url', process.env.MONGOHQ_URL || 'mongodb://localhost/images');

if (app.get('env' === 'development')) {
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

app.use(express["static"](path.join(__dirname, '..', 'public')));

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded());

app.use(cookieParser());

app.use('/', require('./routes/index'));

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

app.listen(app.get('port'), function() {
  return console.log("" + (app.get('app name')) + " running on port " + (app.get('port')));
});
