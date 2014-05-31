module.exports =

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
      res.status(401).render('/', title: 'Unauthorized')
