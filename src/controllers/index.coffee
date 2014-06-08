module.exports =

  # login screen
  index: (req, res) ->
    res.render 'index',
      env: process.env.NODE_ENV
      title: 'Flubr'

  # manage images screen
  loggedin: (req, res) ->
    res.render 'loggedin',
      env: process.env.NODE_ENV
      title: 'Flubr'
      user: req.user
