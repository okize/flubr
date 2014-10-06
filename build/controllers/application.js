var Image, User, getThumbnail, help, navigation, path, _;

path = require('path');

help = require(path.join('..', 'helpers'));

User = require(path.join('..', 'models', 'user'));

Image = require(path.join('..', 'models', 'image'));

_ = require('lodash');

navigation = [
  {
    title: "Add new image",
    href: "addImage",
    icon: "upload"
  }, {
    title: "Image list",
    href: "images",
    icon: "photo"
  }, {
    title: "Manage users",
    href: "users",
    icon: "user"
  }, {
    title: "Log out",
    href: "logout",
    icon: "power-off"
  }
];

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
      var failImageCount, failImagePercentage, images, passImageCount, passImagePercentage, totalImageCount;
      if (err) {
        throw err;
      }
      passImageCount = 0;
      failImageCount = 0;
      images = _.map(results, function(image) {
        var newImage;
        if (image.kind === 'pass') {
          passImageCount++;
        }
        if (image.kind === 'fail') {
          failImageCount++;
        }
        return newImage = {
          id: image._id,
          imageUrl: image.image_url,
          thumbnailUrl: getThumbnail(image.image_url),
          kind: image.kind
        };
      });
      totalImageCount = passImageCount + failImageCount;
      passImagePercentage = (passImageCount / totalImageCount) * 100;
      failImagePercentage = (failImageCount / totalImageCount) * 100;
      return res.render('images', {
        env: process.env.NODE_ENV,
        title: 'Image list',
        pageName: 'images',
        navigation: navigation,
        user: req.user,
        imageList: images,
        passImageCount: passImageCount,
        failImageCount: failImageCount,
        passImagePercentage: passImagePercentage,
        failImagePercentage: failImagePercentage,
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
          dateAdded: help.formatTime(user.created_at)
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
  },
  noUsers: function(req, res) {
    return User.find({}, function(err, users) {
      if (err) {
        throw err;
      }
      if (users.length === 0) {
        return res.render('noUsers', {
          title: 'No users found!',
          pageName: 'users'
        });
      } else {
        return res.redirect('/403');
      }
    });
  }
};
