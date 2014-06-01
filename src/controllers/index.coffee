module.exports =

  # login screen
  index: (req, res) ->
    res.render 'index',
    title: 'Blundercats!'

  # manage images screen
  loggedin: (req, res) ->
    res.render 'loggedin',
    title: 'Manage'
    user: req.user