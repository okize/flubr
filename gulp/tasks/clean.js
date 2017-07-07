// removes distribution folder

const path = require('path');
const gulp = require('gulp');
const clean = require('del');

const config = require('../config');

gulp.task('clean', () => clean([config.dist.appDir, config.dist.cssDir, config.dist.jsDir]));
