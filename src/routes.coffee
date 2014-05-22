module.exports = (app, passport) ->

  # index page (redirect to admin if signed in)
  app.get '/', (req, res, next) ->
    unless req.isAuthenticated()
      routeMvc('index', 'index', req, res, next)
    else
      res.redirect '/admin'

  # admin
  app.all '/admin', ensureAuthenticated, (req, res, next) ->
    routeMvc('admin', 'index', req, res, next)

  # account
  app.all '/account', ensureAuthenticated, (req, res, next) ->
    routeMvc('account', 'index', req, res, next)

  # login
  app.get '/login', passport.authenticate('twitter'), (req, res, next) ->

  app.get '/auth/callback', passport.authenticate('twitter',
    failureRedirect: '/'
  ), (req, res, next) ->
    res.redirect '/admin'

  # logout
  app.all '/logout', (req, res, next) ->
    req.logout()
    res.redirect '/'

  # api
  app.all '/api', (req, res, next) ->
    res.redirect '/'

  app.all '/api/:controller', (req, res, next) ->
    routeMvc(req.params.controller, 'index', req, res, next)

  app.all '/api/:controller/:method', (req, res, next) ->
    routeMvc(req.params.controller, req.params.method, req, res, next)

  app.all '/api/:controller/:method/:id', (req, res, next) ->
    routeMvc(req.params.controller, req.params.method, req, res, next)

  # 404 page not found
  app.all '/*', (req, res) ->
    console.warn "error 404: ", req.url
    res.statusCode = 404
    res.render '404', 404

# render the page based on controller name, method and id
routeMvc = (controllerName, methodName, req, res, next) ->
  controllerName = 'index' if not controllerName?
  controller = null
  try
    controller = require './controllers/' + controllerName
  catch e
    console.warn 'controller not found: ' + controllerName, e
    next()
    return
  data = null
  if typeof controller[methodName] is 'function'
    actionMethod = controller[methodName].bind controller
    actionMethod req, res, next
  else
    console.warn 'method not found: ' + methodName
    next()

# ensure user has been authenticated
ensureAuthenticated = (req, res, next) ->
  unless !req.isAuthenticated()
    return next()
  res.redirect '/'
