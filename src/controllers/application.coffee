navigation =
  'Add image': 'addImage'
  'Image list': 'imageList'
  'Manage users': 'users'
  'Log out': 'logout'

module.exports =

  # add new image page
  addImage: (req, res) ->
    res.render 'addImage',
      env: process.env.NODE_ENV
      title: 'Add new image'
      pageName: 'addImage'
      navigation: navigation
      user: req.user

  # view all images page
  imageList: (req, res) ->
    res.render 'imageList',
      env: process.env.NODE_ENV
      title: 'Image list'
      pageName: 'imageList'
      navigation: navigation
      user: req.user

  # user management page
  users: (req, res) ->
    res.render 'users',
      env: process.env.NODE_ENV
      title: 'Manage users'
      pageName: 'users'
      navigation: navigation
      user: req.user
