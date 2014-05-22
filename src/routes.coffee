module.exports = (app) ->

  # index
  app.all '/', (req, res, next) ->
    routeMvc('index', 'index', req, res, next)

  # admin
  app.all '/admin', (req, res, next) ->
    routeMvc('admin', 'index', req, res, next)

  # login
  app.all '/login', (req, res, next) ->
    res.redirect '/'

  # logout
  app.all '/logout', (req, res, next) ->
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

  # app.use (req, res, next) ->
  #   err = new Error('Not Found')
  #   err.status = 404
  #   next(err)

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