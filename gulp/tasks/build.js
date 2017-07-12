const path = require('path');
const gulp = require('gulp');
const gutil = require('gulp-util');
const runSequence = require('run-sequence');
const stylus = require('gulp-stylus');
const nib = require('nib');
const browserify = require('browserify');
const babelify = require('babelify');
const source = require('vinyl-source-stream');
const buff = require('vinyl-buffer');
const sourcemaps = require('gulp-sourcemaps');

const config = require('../config');

const browserifyOptions = {
  entries: [path.join(config.src.jsDir, config.src.jsEntry)],
  extensions: ['.js', '.jsx'],
  debug: true,
};

const sourcemapOptions = {
  loadMaps: true,
  debug: true,
};

// creates a build
gulp.task('build', (callback) => {
  return runSequence(['clean'], ['build-css', 'build-js'], ['minify-css', 'minify-js'], callback);
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
  return browserify(browserifyOptions)
    .transform('babelify', {
      presets: ['latest'],
      plugins: ['babel-plugin-transform-class-properties'],
    })
    .bundle()
    .pipe(source(config.js.name))
    .pipe(buff())
    .pipe(sourcemaps.init(sourcemapOptions))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.js.dest));
});
