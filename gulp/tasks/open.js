const gulp = require('gulp');
const open = require('gulp-open');

// open app in default browser
gulp.task('open', () =>
  gulp
    .src('./src/app.coffee')
    .pipe(open('', { url: `http://127.0.0.1:${process.env.PORT || 3333}` })),
);