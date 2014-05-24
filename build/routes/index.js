var express, router;

express = require('express');

router = express.Router();

router.get('/', function(req, res) {
  return res.render('index', {
    title: '...'
  });
});

module.exports = router;

/*
//# sourceMappingURL=index.js.map
*/
