var Image, User, getThumbnail, moment, navigation, path, _;

path = require('path');

User = require(path.join('..', 'models', 'user'));

Image = require(path.join('..', 'models', 'image'));

navigation = require(path.join('..', 'navigation.json'));

_ = require('lodash');

moment = require('moment');

getThumbnail = function(url) {
  var thumbnail;
  if (url != null) {
    return thumbnail = (url.substring(0, url.length - 4)) + 's.jpg';
  }
};

module.exports = {
  addImage: function(req, res) {
    return res.render('addImage', {
      env: process.env.NODE_ENV,
      title: 'Add new image',
      pageName: 'addImage',
      navigation: navigation,
      user: req.user
    });
  },
  images: function(req, res) {
    return Image.find({
      deleted: false
    }).sort({
      created_at: 'descending'
    }).exec(function(err, results) {
      var images;
      if (err) {
        throw err;
      }
      images = _.map(results, function(image) {
        var newImage;
        return newImage = {
          id: image._id,
          imageUrl: image.image_url,
          thumbnailUrl: getThumbnail(image.image_url),
          kind: image.kind
        };
      });
      return res.render('images', {
        env: process.env.NODE_ENV,
        title: 'Image list',
        pageName: 'images',
        navigation: navigation,
        user: req.user,
        imageList: images,
        deleted: false
      });
    });
  },
  imagesDeleted: function(req, res) {
    return Image.find({
      deleted: true
    }).sort({
      created_at: 'descending'
    }).exec(function(err, results) {
      var images;
      if (err) {
        throw err;
      }
      images = _.map(results, function(image) {
        var newImage;
        return newImage = {
          id: image._id,
          imageUrl: image.image_url,
          thumbnailUrl: getThumbnail(image.image_url),
          kind: image.kind
        };
      });
      return res.render('images', {
        env: process.env.NODE_ENV,
        title: 'Image list',
        pageName: 'images',
        navigation: navigation,
        user: req.user,
        imageList: images,
        deleted: true
      });
    });
  },
  users: function(req, res) {
    return User.find({}, function(err, users) {
      if (err) {
        throw err;
      }
      users = _.map(users, function(user) {
        var newUser;
        return newUser = {
          id: user.userid,
          name: user.displayName,
          twitterHandle: user.userName,
          avatar: user.avatar,
          dateAdded: moment(user.created_at).format('lll')
        };
      });
      return res.render('users', {
        env: process.env.NODE_ENV,
        title: 'Manage users',
        pageName: 'users',
        navigation: navigation,
        user: req.user,
        userList: users
      });
    });
  }
};
