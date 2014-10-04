moment = require 'moment'
User = require './models/user'

module.exports =

  formatTime: (date) ->
    moment(date).format('lll')

  checkForUser: (req, res) ->
    if req.user?
      true
    else
      false

  # ensure user has been authenticated
  ensureAuthenticated: (req, res, next) ->
    unless !req.isAuthenticated()
      next()
    else
      res.status(401).render('401', title: 'Unauthorized')

  # ensure that no users have been authorized
  ensureNoUsers: (req, res, next) ->
    User.find {}, (err, results) ->
      if err?
        res.status(500).render('500', title: err)
      if results.length == 0
        next()
      else
        res.status(401).render('401', title: 'Unauthorized')