module.exports = {
  index: function(req, res) {
    return res.render('homepage', {
      env: process.env.NODE_ENV,
      title: 'Log in'
    });
  }
};
