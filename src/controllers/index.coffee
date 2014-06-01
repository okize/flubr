module.exports =

  # login screen
  index: (req, res) ->
    res.render 'index',
    title: 'Blundercats!'

  # admin screen
  admin: (req, res) ->
    res.render 'admin',
    title: 'Admin'
    user: req.user