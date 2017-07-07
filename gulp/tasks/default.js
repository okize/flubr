// default task that's run with 'gulp'

const gulp = require('gulp');
const runSequence = require('run-sequence');

gulp.task('default', callback =>
  runSequence(
    'start-mongo',
    'start-app',
    'watch',
    callback,
  ),
);
