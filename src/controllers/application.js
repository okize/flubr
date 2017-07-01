const path = require('path');
const moment = require('moment');
const help = require(path.join('..', 'helpers'));
const User = require(path.join('..', 'models', 'user'));
const Image = require(path.join('..', 'models', 'image'));
const _ = require('lodash');

const navigation = [
  {
    title: "Add new image",
    href: "addImage",
    icon: "icon-upload"
  },
  {
    title: "Image list",
    href: "imageList",
    icon: "icon-photo"
  },
  {
    title: "Manage users",
    href: "users",
    icon: "icon-users"
  },
  {
    title: "Statistics",
    href: "stats",
    icon: "icon-graph2"
  },
  {
    title: "Log out",
    href: "logout",
    icon: "icon-power"
  }
];

const getThumbnail = function(url) {
  if (url != null) {
    let thumbnail;
    return thumbnail = (url.substring(0, url.length - 4)) + 's.jpg';
  }
};

module.exports = {

  // add new image page
  addImage(req, res) {
    return res.render('addImage', {
      env: process.env.NODE_ENV,
      title: 'Add new image',
      pageName: 'addImage',
      navigation,
      user: req.user
    }
    );
  },

  // view all images page
  imageList(req, res) {
    return User.find({}, function(err, users) {
      if (err) { throw err; }
      return Image.find({deleted: false}).sort({created_at: 'descending'}).exec(
        function(err, results) {
          if (err) { throw err; }
          const images = _.map(results, function(image) {
            let newImage;
            const user = _.find(users, { 'userid': image.added_by });
            return newImage = {
              id: image._id,
              imageUrl: image.image_url,
              thumbnailUrl: getThumbnail(image.image_url),
              kind: image.kind,
              added: moment(image.created_at).format('MM-DD-YYYY'),
              addedBy: typeof user !== 'undefined' ? user.displayName : 'Unknown'
            };
          });
          return res.render('imageList', {
            env: process.env.NODE_ENV,
            title: 'Image list',
            pageName: 'imageList',
            navigation,
            user: req.user,
            imageList: images,
            deleted: false
          });
      });
    });
  },

  // view all images page
  imageListDeleted(req, res) {
    return Image.find({deleted: true}).sort({created_at: 'descending'}).exec(
      function(err, results) {
        if (err) { throw err; }
        const images = _.map(results, function(image) {
          let newImage;
          return newImage = {
            id: image._id,
            imageUrl: image.image_url,
            thumbnailUrl: getThumbnail(image.image_url),
            kind: image.kind
          };
        });
        return res.render('imageList', {
          env: process.env.NODE_ENV,
          title: 'Deleted image list',
          pageName: 'imageList',
          navigation,
          user: req.user,
          imageList: images,
          deleted: true
        });
    });
  },

  // statistics page
  stats(req, res) {
    return Image.find({deleted: false}).sort({created_at: 'descending'}).exec(
      function(err, results) {
        if (err) { throw err; }
        let passImageCount = 0;
        let failImageCount = 0;
        const images = _.map(results, function(image) {
          if (image.kind === 'pass') { passImageCount++; }
          if (image.kind === 'fail') { return failImageCount++; }
        });
        const totalImageCount = passImageCount + failImageCount;
        const passImagePercentage = (passImageCount / totalImageCount) * 100;
        const failImagePercentage = (failImageCount / totalImageCount) * 100;
        return res.render('stats', {
          env: process.env.NODE_ENV,
          title: 'Statistics',
          pageName: 'stats',
          navigation,
          user: req.user,
          imageList: images,
          passImageCount,
          failImageCount,
          passImagePercentage,
          failImagePercentage,
          deleted: false
        });
    });
  },

  // user management page
  users(req, res) {
    return User.find({}, function(err, users) {
      if (err) { throw err; }
      users = _.map(users, function(user) {
        let newUser;
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
        navigation,
        user: req.user,
        userList: users
      }
      );
    });
  },

  // check if there are *any* users OR if not a registered user
  noUsers(req, res) {
    return User.find({}, function(err, users) {
      if (err) { throw err; }
      if (users.length === 0) {
        return res.render('noUsers', {
          title: 'No users found!',
          pageName: 'users'
        }
        );
      } else {
        return res.redirect('/403');
      }
    });
  }
};
