var app, bodyParser, coffee, coffeeScript, cookieParser, express, home, images, livereload, logger, mongoose, nib, path, stylus;

path = require('path');

express = require('express');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

livereload = require('connect-livereload');

mongoose = require('mongoose');

coffee = require('coffee-script');

coffeeScript = require('connect-coffee-script');

stylus = require('stylus');

nib = require('nib');

images = require('./controller/images');

home = require('./routes/index');

app = express();

app.set('port', process.env.PORT || 3000);

app.set('views', path.join(__dirname, '..', 'views'));

app.set('view engine', 'jade');

app.set('db-url', process.env.MONGOHQ_URL || 'mongodb://localhost/images');

if (process.env.NODE_ENV === 'development') {
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

app.use(coffeeScript({
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

app.use('/', home);

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

require('./model/image');

app.post('/images', images.create);

app.get('/images', images.retrieve);

app.get('/images/:type', images.retrieve);

app.listen(app.get('port'), function() {
  return console.log("Listening on port " + (app.get('port')));
});

/*
//# sourceMappingURL=app.js.map
*/
