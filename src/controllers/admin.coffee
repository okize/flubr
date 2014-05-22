exports.index = (req, res) ->
  res.render 'admin',
    title: 'Admin'
    user: req.user._json