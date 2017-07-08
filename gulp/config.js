// configuration file for Gulp tasks

const path = require('path');

const root = path.resolve(__dirname, '..');
const assets = path.resolve(root, 'public');
const coffeeDir = `${root}/views/javascripts/`;
const stylusDir = `${root}/views/stylesheets/`;

module.exports = {
  root,
  tests: `${root}/tests/**/*.js`,
  taskDir: `${root}/gulp/tasks/`,
  main: `${root}/src/app.js`,

  // DO NOT restart node app when files change in these directories
  appIgnoreDirs: [
    '.git',
    'node_modules/**/node_modules',
    'gulp/**',
    'views/**',
    'tests/**',
  ],

  // asset sources
  src: {
    app: `${root}/src/**/*.js`,
    favicons: `${root}/assets/favicons/`,
    pug: `${root}/views/**/**/*.pug`,
    stylus: `${stylusDir}**/*.styl`,
    stylusEntry: 'styles.styl',
    stylusDir,
    coffee: `${coffeeDir}*.coffee`,
    coffeeEntry: 'scripts.coffee',
    coffeeDir,
  },

  // asset compilation targets
  dist: {
    appDir: `${root}/build/`,
    cssName: 'styles.css',
    cssDir: `${assets}/stylesheets/`,
    jsName: 'scripts.js',
    jsDir: `${assets}/javascripts/`,
  },
};
