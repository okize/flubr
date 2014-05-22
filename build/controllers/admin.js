exports.index = function(req, res) {
  return res.render('admin', {
    title: 'Admin',
    user: req.user._json
  });
};
