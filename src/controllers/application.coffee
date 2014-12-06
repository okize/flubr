path = require 'path'
moment = require 'moment'
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
    href: "imageList",
    icon: "photo"
  },
  {
    title: "Manage users",
    href: "users",
    icon: "user"
  },
  {
    title: "Statistics",
    href: "stats",
    icon: "bar-chart-o"
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
  imageList: (req, res) ->
    User.find {}, (err, users) ->
      throw err if err
      Image.find(deleted: false).sort(created_at: 'descending').exec(
        (err, results) ->
          throw err if err
          images = _.map results, (image) ->
            user = _.find(users, { 'userid': image.added_by })
            newImage =
              id: image._id
              imageUrl: image.image_url
              thumbnailUrl: getThumbnail(image.image_url)
              kind: image.kind
              added: moment(image.created_at).format('MM-DD-YYYY')
              addedBy: if typeof user != 'undefined' then user.displayName else 'Unknown'
          res.render 'imageList',
            env: process.env.NODE_ENV
            title: 'Image list'
            pageName: 'imageList'
            navigation: navigation
            user: req.user
            imageList: images
            deleted: false
      )

  # view all images page
  imageListDeleted: (req, res) ->
    Image.find(deleted: true).sort(created_at: 'descending').exec(
      (err, results) ->
        throw err if err
        images = _.map results, (image) ->
          newImage =
            id: image._id
            imageUrl: image.image_url
            thumbnailUrl: getThumbnail(image.image_url)
            kind: image.kind
        res.render 'imageList',
          env: process.env.NODE_ENV
          title: 'Deleted image list'
          pageName: 'imageList'
          navigation: navigation
          user: req.user
          imageList: images
          deleted: true
    )

  # statistics page
  stats: (req, res) ->
    Image.find(deleted: false).sort(created_at: 'descending').exec(
      (err, results) ->
        throw err if err
        passImageCount = 0
        failImageCount = 0
        images = _.map results, (image) ->
          passImageCount++ if image.kind == 'pass'
          failImageCount++ if image.kind == 'fail'
        totalImageCount = passImageCount + failImageCount
        passImagePercentage = (passImageCount / totalImageCount) * 100
        failImagePercentage = (failImageCount / totalImageCount) * 100
        res.render 'stats',
          env: process.env.NODE_ENV
          title: 'Statistics'
          pageName: 'stats'
          navigation: navigation
          user: req.user
          imageList: images
          passImageCount: passImageCount
          failImageCount: failImageCount
          passImagePercentage: passImagePercentage
          failImagePercentage: failImagePercentage
          deleted: false
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

  # check if there are *any* users OR if not a registered user
  noUsers: (req, res) ->
    User.find {}, (err, users) ->
      throw err if err
      if users.length == 0
        res.render 'noUsers',
          title: 'No users found!'
          pageName: 'users'
      else
        res.redirect '/403'
