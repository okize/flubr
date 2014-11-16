var application, help, homepage, images, users;

homepage = require('./controllers/homepage');

application = require('./controllers/application');

images = require('./controllers/images');

users = require('./controllers/users');

help = require('./helpers');

module.exports = function(app, passport) {
  app.get('/', function(req, res, next) {
    if (!req.isAuthenticated()) {
      return homepage.index(req, res, next);
    } else {
      return res.redirect('/addImage');
    }
  });
  app.get('/addImage', help.ensureAuthenticated, function(req, res, next) {
    return application.addImage(req, res, next);
  });
  app.get('/imageList', help.ensureAuthenticated, function(req, res, next) {
    return application.imageList(req, res, next);
  });
  app.get('/imageListDeleted', help.ensureAuthenticated, function(req, res, next) {
    return application.imageListDeleted(req, res, next);
  });
  app.get('/stats', help.ensureAuthenticated, function(req, res, next) {
    return application.stats(req, res, next);
  });
  app.get('/users', help.ensureAuthenticated, function(req, res, next) {
    return application.users(req, res, next);
  });
  app.get('/noUsers', function(req, res, next) {
    return application.noUsers(req, res, next);
  });
  app.post('/addFirstUser', help.ensureNoUsers, function(req, res, next) {
    return users.create(req, res, next);
  });
  app.get('/login', passport.authenticate('twitter'));
  app.all('/logout', function(req, res, next) {
    req.logout();
    return res.redirect('/');
  });
  app.get('/auth', passport.authenticate('twitter', {
    failureRedirect: '/noUsers'
  }), function(req, res) {
    return res.redirect('/');
  });
  app.all('/api', function(req, res, next) {
    return res.redirect('/');
  });
  app.get('/api/images', help.ensureAuthenticated, function(req, res, next) {
    return images.index(req, res, next);
  });
  app.get('/api/images/deleted', help.ensureAuthenticated, function(req, res, next) {
    return images.indexDeleted(req, res, next);
  });
  app.get('/api/images/:id', help.ensureAuthenticated, function(req, res, next) {
    return images.show(req, res, next);
  });
  app.get('/api/images/random/:id', function(req, res, next) {
    return images.random(req, res, next);
  });
  app.post('/api/images', help.ensureAuthenticated, function(req, res, next) {
    return images.create(req, res, next);
  });
  app.put('/api/images/:id', help.ensureAuthenticated, function(req, res, next) {
    return images.update(req, res, next);
  });
  app["delete"]('/api/images/:id', help.ensureAuthenticated, function(req, res, next) {
    return images["delete"](req, res, next);
  });
  app.get('/api/users', help.ensureAuthenticated, function(req, res, next) {
    return users.index(req, res, next);
  });
  app.post('/api/users', help.ensureAuthenticated, function(req, res, next) {
    return users.create(req, res, next);
  });
  app.put('/api/users/:id', help.ensureAuthenticated, function(req, res, next) {
    return users.update(req, res, next);
  });
  app["delete"]('/api/users/:id', help.ensureAuthenticated, function(req, res, next) {
    return users["delete"](req, res, next);
  });
  app.all('/401', function(req, res) {
    res.statusCode = 401;
    return res.render('401', 401);
  });
  app.all('/403', function(req, res) {
    res.statusCode = 403;
    return res.render('403', 403);
  });
  return app.all('/*', function(req, res) {
    console.warn("error 404: " + req.url);
    res.statusCode = 404;
    return res.render('404', 404);
  });
};
