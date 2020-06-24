const _ = require('lodash');
const moment = require('moment');

const help = require('../helpers');
const User = require('../models/user');
const Image = require('../models/image');

const navigation = [
  {
    title: 'Add new image',
    href: 'addImage',
    icon: 'icon-upload',
  },
  {
    title: 'Image list',
    href: 'imageList',
    icon: 'icon-photo',
  },
  {
    title: 'Manage users',
    href: 'users',
    icon: 'icon-users',
  },
  {
    title: 'Statistics',
    href: 'stats',
    icon: 'icon-graph2',
  },
  {
    title: 'Log out',
    href: 'logout',
    icon: 'icon-power',
  },
];

const getThumbnail = (url) => {
  if (url !== null) {
    return `${url.substring(0, url.length - 4)}s.jpg`;
  }
  return null;
};

module.exports = {

  // add new image page
  addImage(req, res) {
    return res.render('addImage', {
      env: process.env.NODE_ENV,
      title: 'Add new image',
      pageName: 'addImage',
      navigation,
      user: req.user,
    });
  },

  // view all images page
  imageList(req, res) {
    return User.find({}, (error, users) => {
      if (error) { throw error; }
      return Image.find({ deleted: false }).sort({ created_at: 'descending' }).exec((err, results) => {
        if (err) { throw err; }
        const images = _.map(results, (image) => {
          const user = _.find(users, { userid: image.added_by });
          return {
            id: image._id,
            imageUrl: image.image_url,
            thumbnailUrl: getThumbnail(image.image_url),
            kind: image.kind,
            added: moment(image.created_at).format('MM-DD-YYYY'),
            addedBy: typeof user !== 'undefined' ? user.displayName : 'Unknown',
          };
        });
        return res.render('imageList', {
          env: process.env.NODE_ENV,
          title: 'Image list',
          pageName: 'imageList',
          navigation,
          user: req.user,
          imageList: images,
          deleted: false,
        });
      });
    });
  },

  // view all images page
  imageListDeleted(req, res) {
    return Image.find({ deleted: true }).sort({ created_at: 'descending' }).exec(
      (err, results) => {
        if (err) { throw err; }
        const images = _.map(results, (image) => ({
          id: image._id,
          imageUrl: image.image_url,
          thumbnailUrl: getThumbnail(image.image_url),
          kind: image.kind,
        }));
        return res.render('imageList', {
          env: process.env.NODE_ENV,
          title: 'Deleted image list',
          pageName: 'imageList',
          navigation,
          user: req.user,
          imageList: images,
          deleted: true,
        });
      },
    );
  },

  // statistics page
  stats(req, res) {
    return Image.find({ deleted: false }).sort({ created_at: 'descending' }).exec((err, results) => {
      if (err) { throw err; }
      let passImageCount = 0;
      let failImageCount = 0;
      results.forEach((image) => {
        if (image.kind === 'pass') { passImageCount += 1; }
        if (image.kind === 'fail') { failImageCount += 1; }
      });
      const totalImageCount = passImageCount + failImageCount;
      const passImagePercentage = (passImageCount / totalImageCount) * 100;
      const failImagePercentage = (failImageCount / totalImageCount) * 100;
      const locals = {
        env: process.env.NODE_ENV,
        title: 'Statistics',
        pageName: 'stats',
        navigation,
        user: req.user,
        totalImageCount,
        passImageCount,
        failImageCount,
        passImagePercentage,
        failImagePercentage,
        deleted: false,
      };

      return res.render('stats', locals);
    });
  },

  // user management page
  users(req, res) {
    return User.find({}, (err, users) => {
      if (err) { throw err; }
      const userList = _.map(users, (user) => ({
        id: user.userid,
        name: user.displayName,
        twitterHandle: user.userName,
        avatar: user.avatar,
        dateAdded: help.formatTime(user.created_at),
      }));
      return res.render('users', {
        env: process.env.NODE_ENV,
        title: 'Manage users',
        pageName: 'users',
        navigation,
        user: req.user,
        userList,
      });
    });
  },

  // check if there are *any* users OR if not a registered user
  noUsers(req, res) {
    return User.find({}, (err, users) => {
      if (err) { throw err; }
      if (users.length === 0) {
        return res.render('noUsers', {
          title: 'No users found!',
          pageName: 'users',
        });
      }
      return res.redirect('/403');
    });
  },
};
