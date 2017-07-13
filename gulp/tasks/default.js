const gulp = require('gulp');
const runSequence = require('run-sequence');

// default task that's run with 'gulp'
gulp.task('default', (callback) => {
  return runSequence('start-mongo', 'start-app', 'watch', callback);
});
