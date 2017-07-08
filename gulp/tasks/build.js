const gulp = require('gulp');
const gutil = require('gulp-util');
const source = require('vinyl-source-stream');
const runSequence = require('run-sequence');
const coffee = require('gulp-coffee');
const browserify = require('browserify');
const coffeeify = require('coffeeify');
const stylus = require('gulp-stylus');
const nib = require('nib');

const config = require('../config');

// creates a build
gulp.task('build', callback => runSequence(
  ['clean'],
  ['build-css', 'build-js', 'build-app'],
  ['minify-css', 'minify-js'],
  callback,
));

// builds coffeescript source into deployable javascript
gulp.task('build-app', () => {
  gulp
    .src(config.src.app)
    .pipe(coffee({
      bare: true,
      sourceMap: false,
    }).on('error', gutil.log))
    .pipe(gulp.dest(config.dist.appDir));
});

// builds the css
gulp.task('build-css', () => {
  gulp
    .src(`${config.src.stylusDir}${config.src.stylusEntry}`)
    .pipe(stylus({
      linenos: false,
      use: [nib()],
    }))
    .pipe(gulp.dest(config.dist.cssDir));
});

// builds the front-end javascript
gulp.task('build-js', () => {
  browserify({ extensions: ['.coffee'], debug: true })
    .add(`${config.src.coffeeDir}${config.src.coffeeEntry}`)
    .transform(coffeeify)
    .bundle()
    .on('error', gutil.log)
    .pipe(source('scripts.js'))
    .pipe(gulp.dest(config.dist.jsDir));
});
