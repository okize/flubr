var ensureAuthenticated, routeMvc;

module.exports = function(app, passport) {
  app.get('/', function(req, res, next) {
    if (!req.isAuthenticated()) {
      return routeMvc('index', 'index', req, res, next);
    } else {
      return res.redirect('/admin');
    }
  });
  app.all('/admin', ensureAuthenticated, function(req, res, next) {
    return routeMvc('admin', 'index', req, res, next);
  });
  app.get('/login', passport.authenticate('twitter'), function(req, res, next) {});
  app.get('/auth/callback', passport.authenticate('twitter', {
    failureRedirect: '/'
  }), function(req, res, next) {
    return res.redirect('/admin');
  });
  app.all('/logout', function(req, res, next) {
    req.logout();
    return res.redirect('/');
  });
  app.all('/api', function(req, res, next) {
    return res.redirect('/');
  });
  app.all('/api/:controller', function(req, res, next) {
    return routeMvc(req.params.controller, 'index', req, res, next);
  });
  app.all('/api/:controller/:method', function(req, res, next) {
    return routeMvc(req.params.controller, req.params.method, req, res, next);
  });
  app.all('/api/:controller/:method/:id', function(req, res, next) {
    return routeMvc(req.params.controller, req.params.method, req, res, next);
  });
  return app.all('/*', function(req, res) {
    console.warn("error 404: ", req.url);
    res.statusCode = 404;
    return res.render('404', 404);
  });
};

routeMvc = function(controllerName, methodName, req, res, next) {
  var actionMethod, controller, data, e;
  if (controllerName == null) {
    controllerName = 'index';
  }
  controller = null;
  try {
    controller = require('./controllers/' + controllerName);
  } catch (_error) {
    e = _error;
    console.warn('controller not found: ' + controllerName, e);
    next();
    return;
  }
  data = null;
  if (typeof controller[methodName] === 'function') {
    actionMethod = controller[methodName].bind(controller);
    return actionMethod(req, res, next);
  } else {
    console.warn('method not found: ' + methodName);
    return next();
  }
};

ensureAuthenticated = function(req, res, next) {
  if (!!req.isAuthenticated()) {
    return next();
  }
  return res.redirect('/');
};
