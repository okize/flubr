// run a node debugger

const gulp = require('gulp');
const bg = require('gulp-bg');

const config = require('../config');

gulp.task('debug', () => bg('./node_modules/.bin/node-debug', config.main));
