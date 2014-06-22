index = require './controllers/index'
images = require './controllers/images'
users = require './controllers/users'
helpers = require './helpers'

module.exports = (app, passport) ->

  # home page; redirects to addImage after auth
  app.get '/', (req, res, next) ->
    unless req.isAuthenticated()
      index.homepage req, res, next
    else
      res.redirect '/addImage'

  # add new image
  app.get '/addImage', helpers.ensureAuthenticated, (req, res, next) ->
    index.addImage req, res, next

  # view all images
  app.get '/viewImages', helpers.ensureAuthenticated, (req, res, next) ->
    index.viewImages req, res, next

  # manage users
  app.get '/users', helpers.ensureAuthenticated, (req, res, next) ->
    index.users req, res, next

  # login
  app.get '/login', passport.authenticate('twitter'), (req, res, next) ->

  # logout
  app.all '/logout', (req, res, next) ->
    req.logout()
    res.redirect '/'

  # auth callback for twitter
  app.get '/auth/callback', passport.authenticate('twitter',
    failureRedirect: '/'
  ), (req, res, next) ->
    res.redirect '/'

  # api
  app.all '/api', (req, res, next) ->
    res.redirect '/'

  # list all images
  app.get '/api/images', (req, res, next) ->
    images.index req, res, next

  # list single image by id
  app.get '/api/images/:id', (req, res, next) ->
    images.show req, res, next

  # display random pass/fail image
  app.get '/api/images/random/:id', (req, res, next) ->
    images.random req, res, next

  # add new image
  app.post '/api/images', helpers.ensureAuthenticated, (req, res, next) ->
    images.create req, res, next

  # update image
  app.put '/api/images/:id', helpers.ensureAuthenticated, (req, res, next) ->
    images.update req, res, next

  # delete image
  app.delete '/api/images/:id', helpers.ensureAuthenticated, (req, res, next) ->
    images.delete req, res, next

  # list all users
  app.get '/api/users', helpers.ensureAuthenticated, (req, res, next) ->
    users.index req, res, next

  # add new user
  app.post '/api/users', helpers.ensureAuthenticated, (req, res, next) ->
    users.create req, res, next

  # update user
  app.put '/api/users/:id', helpers.ensureAuthenticated, (req, res, next) ->
    users.update req, res, next

  # delete user
  app.delete '/api/users/:id', helpers.ensureAuthenticated, (req, res, next) ->
    users.delete req, res, next

  # page not found
  app.all '/*', (req, res) ->
    console.warn "error 404: ", req.url
    res.statusCode = 404
    res.render '404', 404
