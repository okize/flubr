const gulp = require('gulp');
const mocha = require('gulp-mocha');
const config = require('../config');

// runs tests
gulp.task('test', () => gulp
  .src(config.tests, { read: false })
  .pipe(mocha({ reporter: 'spec' })));
