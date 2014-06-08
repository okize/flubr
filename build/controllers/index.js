module.exports = {
  index: function(req, res) {
    return res.render('index', {
      env: process.env.NODE_ENV,
      title: 'Flubr'
    });
  },
  loggedin: function(req, res) {
    return res.render('loggedin', {
      env: process.env.NODE_ENV,
      title: 'Flubr',
      user: req.user
    });
  }
};
