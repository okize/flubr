var express, path, router;

path = require('path');

express = require('express');

router = express.Router();

router.get('/', function(req, res) {
  return res.render('index', {
    title: 'Blundercats!'
  });
});

require(path.join('./model/image'));

router.post('/images', images.create);

router.get('/images', images.retrieve);

router.get('/images/:type', images.retrieve);

module.exports = router;
