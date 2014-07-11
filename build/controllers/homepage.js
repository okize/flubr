var coffee, css, cssDir, fs, js, jsDir, nib, path, rupture, stylus;

fs = require('fs');

path = require('path');

coffee = require('coffee-script');

stylus = require('stylus');

nib = require('nib');

rupture = require('rupture');

cssDir = path.join(__dirname, '..', '..', 'views', 'stylesheets');

css = stylus(fs.readFileSync(cssDir + '/homepage.styl', 'utf8')).set('paths', [cssDir]).set('compress', true).use(rupture()).use(nib()).render();

jsDir = path.join(__dirname, '..', '..', 'views', 'javascripts');

js = coffee.compile(fs.readFileSync(jsDir + '/homepage.coffee', 'utf8'), {
  bare: false,
  header: false
});

module.exports = {
  index: function(req, res) {
    return res.render('homepage', {
      env: process.env.NODE_ENV,
      title: 'Log in',
      css: css,
      js: js
    });
  }
};
