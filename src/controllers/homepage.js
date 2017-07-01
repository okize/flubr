module.exports = {

  // homepage
  index(req, res) {
    return res.render('homepage', {
      env: process.env.NODE_ENV,
      title: 'Log in'
    }
    );
  }
};
