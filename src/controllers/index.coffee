module.exports =

  # homepage
  homepage: (req, res) ->
    res.render 'homepage',
      env: process.env.NODE_ENV
      title: 'Flubr'

  # add new image page
  addImage: (req, res) ->
    res.render 'addImage',
      env: process.env.NODE_ENV
      title: 'Add new image - Flubr'
      user: req.user

  # view all images page
  viewImages: (req, res) ->
    res.render 'viewImages',
      env: process.env.NODE_ENV
      title: 'View all images - Flubr'
      user: req.user
