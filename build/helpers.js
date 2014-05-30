module.exports = {
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
      return res.redirect('/');
    }
  }
};
