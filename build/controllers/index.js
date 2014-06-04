module.exports = {
  index: function(req, res) {
    return res.render('index', {
      title: 'Pass-fail Images'
    });
  },
  loggedin: function(req, res) {
    return res.render('loggedin', {
      title: 'Manage',
      user: req.user
    });
  }
};
