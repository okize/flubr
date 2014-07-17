path = require 'path'
help = require path.join('..', 'helpers')
User = require path.join('..', 'models', 'user')
Image = require path.join('..', 'models', 'image')
_ = require 'lodash'

navigation = [
  {
    title: "Add new image",
    href: "addImage",
    icon: "upload"
  },
  {
    title: "Image list",
    href: "images",
    icon: "photo"
  },
  {
    title: "Manage users",
    href: "users",
    icon: "user"
  },
  {
    title: "Log out",
    href: "logout",
    icon: "power-off"
  }
]

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
        passImageCount = 0
        failImageCount = 0
        images = _.map results, (image) ->
          passImageCount++ if image.kind == 'pass'
          failImageCount++ if image.kind == 'fail'
          newImage =
            id: image._id
            imageUrl: image.image_url
            thumbnailUrl: getThumbnail(image.image_url)
            kind: image.kind
        totalImageCount = passImageCount + failImageCount
        passImagePercentage = (passImageCount / totalImageCount) * 100
        failImagePercentage = (failImageCount / totalImageCount) * 100
        res.render 'images',
          env: process.env.NODE_ENV
          title: 'Image list'
          pageName: 'images'
          navigation: navigation
          user: req.user
          imageList: images
          passImageCount: passImageCount
          failImageCount: failImageCount
          passImagePercentage: passImagePercentage
          failImagePercentage: failImagePercentage
          deleted: false
    )

  # view all images page
  imagesDeleted: (req, res) ->
    Image.find(deleted: true).sort(created_at: 'descending').exec(
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
          deleted: true
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
          dateAdded: help.formatTime(user.created_at)
      res.render 'users',
        env: process.env.NODE_ENV
        title: 'Manage users'
        pageName: 'users'
        navigation: navigation
        user: req.user
        userList: users