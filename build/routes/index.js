var express, router;

express = require('express');

router = express.Router();

router.get('/', function(req, res) {
  return res.render('index', {
    title: 'Blundercats!'
  });
});

module.exports = router;
