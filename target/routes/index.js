// Generated by CoffeeScript 1.7.1
var express, router;

express = require('express');

router = express.Router();

router.get('/', function(req, res) {
  return res.render('index', {
    title: 'Blundercats!'
  });
});

module.exports = router;

//# sourceMappingURL=index.map
