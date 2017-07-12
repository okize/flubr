const gulp = require('gulp');
const clean = require('del');

const config = require('../config');

// removes distribution folder
gulp.task('clean', () => {
  return clean([
    config.dist.cssDir,
    config.dist.jsDir,
  ]);
});
