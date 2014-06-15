module.exports =

  # homepage
  homepage: (req, res) ->
    res.render 'homepage',
      env: process.env.NODE_ENV
      title: 'Flubr'

  # application
  application: (req, res) ->
    res.render 'application',
      env: process.env.NODE_ENV
      title: 'Flubr'
      user: req.user
