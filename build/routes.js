var application, helpers, homepage, images, users;

homepage = require('./controllers/homepage');

application = require('./controllers/application');

images = require('./controllers/images');

users = require('./controllers/users');

helpers = require('./helpers');

module.exports = function(app, passport) {
  app.get('/', function(req, res, next) {
    if (!req.isAuthenticated()) {
      return homepage.index(req, res, next);
    } else {
      return res.redirect('/addImage');
    }
  });
  app.get('/addImage', helpers.ensureAuthenticated, function(req, res, next) {
    return application.addImage(req, res, next);
  });
  app.get('/images', helpers.ensureAuthenticated, function(req, res, next) {
    return application.images(req, res, next);
  });
  app.get('/imagesDeleted', helpers.ensureAuthenticated, function(req, res, next) {
    return application.imagesDeleted(req, res, next);
  });
  app.get('/users', helpers.ensureAuthenticated, function(req, res, next) {
    return application.users(req, res, next);
  });
  app.get('/login', passport.authenticate('twitter'));
  app.all('/logout', function(req, res, next) {
    req.logout();
    return res.redirect('/');
  });
  app.get('/auth', passport.authenticate('twitter', {
    successRedirect: '/addImage',
    failureRedirect: '/failed'
  }));
  app.all('/api', function(req, res, next) {
    return res.redirect('/');
  });
  app.get('/api/images', function(req, res, next) {
    return images.index(req, res, next);
  });
  app.get('/api/images/deleted', function(req, res, next) {
    return images.indexDeleted(req, res, next);
  });
  app.get('/api/images/:id', function(req, res, next) {
    return images.show(req, res, next);
  });
  app.get('/api/images/random/:id', function(req, res, next) {
    return images.random(req, res, next);
  });
  app.post('/api/images', helpers.ensureAuthenticated, function(req, res, next) {
    return images.create(req, res, next);
  });
  app.put('/api/images/:id', helpers.ensureAuthenticated, function(req, res, next) {
    return images.update(req, res, next);
  });
  app["delete"]('/api/images/:id', helpers.ensureAuthenticated, function(req, res, next) {
    return images["delete"](req, res, next);
  });
  app.get('/api/users', helpers.ensureAuthenticated, function(req, res, next) {
    return users.index(req, res, next);
  });
  app.post('/api/users', helpers.ensureAuthenticated, function(req, res, next) {
    return users.create(req, res, next);
  });
  app.put('/api/users/:id', helpers.ensureAuthenticated, function(req, res, next) {
    return users.update(req, res, next);
  });
  app["delete"]('/api/users/:id', helpers.ensureAuthenticated, function(req, res, next) {
    return users["delete"](req, res, next);
  });
  return app.all('/*', function(req, res) {
    console.warn("error 404: ", req.url);
    res.statusCode = 404;
    return res.render('404', 404);
  });
};
