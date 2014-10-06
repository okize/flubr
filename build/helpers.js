var User, moment;

moment = require('moment');

User = require('./models/user');

module.exports = {
  formatTime: function(date) {
    return moment(date).format('lll');
  },
  checkForUser: function(req, res) {
    if (req.user != null) {
      return true;
    } else {
      return false;
    }
  },
  ensureAuthenticated: function(req, res, next) {
    if (!!req.isAuthenticated()) {
      return next();
    } else {
      return res.status(401).render('401', {
        title: 'Unauthorized'
      });
    }
  },
  ensureNoUsers: function(req, res, next) {
    return User.find({}, function(err, results) {
      if (err != null) {
        res.status(500).render('500', {
          title: err
        });
      }
      if (results.length === 0) {
        return next();
      } else {
        return res.status(401).render('401', {
          title: 'Unauthorized'
        });
      }
    });
  }
};
