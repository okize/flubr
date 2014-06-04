module.exports =

  # login screen
  index: (req, res) ->
    res.render 'index',
    title: 'Flubr'

  # manage images screen
  loggedin: (req, res) ->
    res.render 'loggedin',
    title: 'Manage'
    user: req.user