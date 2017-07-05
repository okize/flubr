const moment = require('moment');
const User = require('./models/user');

module.exports = {

  formatTime(date) {
    return moment(date).format('lll');
  },

  checkForUser(req) {
    if (req.user != null) {
      return true;
    }
    return false;
  },

  // ensure user has been authenticated
  ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    }
    return res.status(401).render('401', { title: 'Unauthorized' });
  },

  // ensure that no users have been authorized
  ensureNoUsers(req, res, next) {
    return User.find({}, (err, results) => {
      if (err != null) {
        res.status(500).render('500', { title: err });
      }
      if (results.length === 0) {
        return next();
      }
      return res.status(401).render('401', { title: 'Unauthorized' });
    });
  },
};
