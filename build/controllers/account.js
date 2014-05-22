exports.index = function(req, res) {
  return res.render('account', {
    title: 'Account',
    user: req.user
  });
};
