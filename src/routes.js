const homepage = require('./controllers/homepage');
const application = require('./controllers/application');
const images = require('./controllers/images');
const users = require('./controllers/users');
const versions = require('./controllers/versions');
const help = require('./helpers');

module.exports = function (app, passport) {
  // home page; redirects to addImage after auth
  app.get('/', (req, res, next) => {
    if (!req.isAuthenticated()) {
      return homepage.index(req, res, next);
    }
    return res.redirect('/addImage');
  });

  // add new image
  app.get('/addImage', help.ensureAuthenticated, (req, res, next) => application.addImage(req, res, next));

  // view all images
  app.get('/imageList', help.ensureAuthenticated, (req, res, next) => application.imageList(req, res, next));

  // view all deleted images
  // NOTE: this is not in the navigation
  app.get('/imageListDeleted', help.ensureAuthenticated, (req, res, next) => application.imageListDeleted(req, res, next));

  // view application stats
  app.get('/stats', help.ensureAuthenticated, (req, res, next) => application.stats(req, res, next));

  // manage users
  app.get('/users', help.ensureAuthenticated, (req, res, next) => application.users(req, res, next));

  // no authorized users for application
  app.get('/noUsers', (req, res, next) => application.noUsers(req, res, next));

  // add first user
  app.post('/addFirstUser', help.ensureNoUsers, (req, res, next) => users.create(req, res, next));

  // login
  app.get('/login', passport.authenticate('twitter'));

  // logout
  app.all('/logout', (req, res, next) => {
    req.logout();
    return res.redirect('/');
  });

  // auth callback for twitter
  app.get('/auth', passport.authenticate('twitter', { failureRedirect: '/noUsers' }), (req, res) => res.redirect('/'));

  // api
  app.all('/api', (req, res, next) => res.redirect('/'));

  // list all images
  app.get('/api/images', help.ensureAuthenticated, (req, res, next) => images.index(req, res, next));

  // list all deleted images
  app.get('/api/images/deleted', help.ensureAuthenticated, (req, res, next) => images.indexDeleted(req, res, next));

  // list single image by id
  app.get('/api/images/:id', help.ensureAuthenticated, (req, res, next) => images.show(req, res, next));

  // display random pass/fail image
  app.get('/api/images/random/:id', (req, res, next) => images.random(req, res, next));

  // add new image
  app.post('/api/images', help.ensureAuthenticated, (req, res, next) => images.create(req, res, next));

  // update image
  app.put('/api/images/:id', help.ensureAuthenticated, (req, res, next) => images.update(req, res, next));

  // delete image
  app.delete('/api/images/:id', help.ensureAuthenticated, (req, res, next) => images.delete(req, res, next));

  // list all users
  app.get('/api/users', help.ensureAuthenticated, (req, res, next) => users.index(req, res, next));

  // add new user
  app.post('/api/users', help.ensureAuthenticated, (req, res, next) => users.create(req, res, next));

  // update user
  app.put('/api/users/:id', help.ensureAuthenticated, (req, res, next) => users.update(req, res, next));

  // delete user
  app.delete('/api/users/:id', help.ensureAuthenticated, (req, res, next) => users.delete(req, res, next));

  // get local version of application
  app.get('/api/localAppVersion', (req, res, next) => versions.getLocalVersion(req, res, next));

  // get remote version of application
  app.get('/api/remoteAppVersion', (req, res, next) => versions.getRemoteVersion(req, res, next));

  // unauthorized
  app.all('/401', (req, res) => {
    res.statusCode = 401;
    return res.render('401', 401);
  });

  // forbidden
  app.all('/403', (req, res) => {
    res.statusCode = 403;
    return res.render('403', 403);
  });

  // page not found
  return app.all('/*', (req, res) => {
    console.warn(`error 404: ${req.url}`);
    res.statusCode = 404;
    return res.render('404', 404);
  });
};
