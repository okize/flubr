exports.index = (req, res) ->
  res.render 'account',
    title: 'Account'
    user: req.user