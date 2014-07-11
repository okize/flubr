module.exports =

  # homepage
  index: (req, res) ->
    res.render 'homepage',
      env: process.env.NODE_ENV
      title: 'Log in'
