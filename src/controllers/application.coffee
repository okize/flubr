path = require 'path'
User = require path.join('..', 'models', 'user')
Image = require path.join('..', 'models', 'image')
_ = require 'lodash'
moment = require 'moment'
navigation =
  'Add new image': 'addImage'
  'Image list': 'images'
  'Manage users': 'users'
  'Log out': 'logout'

getThumbnail = (url) ->
  if url?
    thumbnail = (url.substring(0, url.length - 4)) + 's.jpg'

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
  images: (req, res) ->
    Image.find(deleted: false).sort(created_at: 'descending').exec(
      (err, results) ->
        throw err if err
        images = _.map results, (image) ->
          newImage =
            id: image._id
            imageUrl: image.image_url
            thumbnailUrl: getThumbnail(image.image_url)
            kind: image.kind
        res.render 'images',
          env: process.env.NODE_ENV
          title: 'Image list'
          pageName: 'images'
          navigation: navigation
          user: req.user
          imageList: images
    )

  # user management page
  users: (req, res) ->
    User.find {}, (err, users) ->
      throw err if err
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