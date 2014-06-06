module.exports = {
  index: function(req, res) {
    return res.render('index', {
      title: 'Flubr'
    });
  },
  loggedin: function(req, res) {
    return res.render('loggedin', {
      title: 'Manage',
      user: req.user
    });
  }
};
