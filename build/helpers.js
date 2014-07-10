var moment;

moment = require('moment');

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
  }
};
