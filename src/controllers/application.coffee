path = require 'path'
User = require path.join('..', 'models', 'user')
_ = require 'lodash'
moment = require 'moment'
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
    User.find {}, (err, users) ->
      console.log users
      users = _.map users, (user) ->
        newUser =
          id: user.userid
          name: user.displayName
          twitterHandle: user.userName
          avatar: user.avatar
          dateAdded: moment(user.created_at).format('lll')
      res.render 'users',
        env: process.env.NODE_ENV
        title: 'Manage users'
        pageName: 'users'
        navigation: navigation
        user: req.user
        userList: users