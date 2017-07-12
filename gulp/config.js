// configuration file for Gulp tasks

const path = require('path');

const root = path.resolve(__dirname, '..');
const assets = path.resolve(root, 'public');
const jsDir = `${root}/views/javascripts/`;
const stylusDir = `${root}/views/stylesheets/`;

module.exports = {
  root,
  tests: `${root}/tests/**/*.js`,
  taskDir: `${root}/gulp/tasks/`,
  main: `${root}/src/app.js`,

  // asset sources
  src: {
    app: `${root}/src/**/*.js`,
    favicons: `${root}/assets/favicons/`,
    templates: `${root}/views/**/**/*.pug`,
    stylus: `${stylusDir}**/*.styl`,
    stylusEntry: 'styles.styl',
    stylusDir,
    js: `${jsDir}*.js`,
    jsEntry: 'scripts.js',
    jsDir,
  },

  // asset compilation targets
  dist: {
    cssName: 'styles.css',
    cssDir: `${assets}/stylesheets/`,
    jsName: 'scripts.js',
    jsDir: `${assets}/javascripts/`,
  },
};
