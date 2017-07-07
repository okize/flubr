// minifies css & js

const path = require('path');
const gulp = require('gulp');
const rename = require('gulp-rename');
const minifyCss = require('gulp-clean-css');
const uglify = require('gulp-uglify');
const sourcemaps = require('gulp-sourcemaps');

const config = require('../config');

gulp.task('minify', [
  'minify-css',
  'minify-js',
]);

gulp.task('minify-css', () =>
  gulp
    .src(`${config.dist.cssDir}/${config.dist.cssName}`)
    .pipe(sourcemaps.init())
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.dist.cssDir)),
);

gulp.task('minify-js', () =>
  gulp
    .src(`${config.dist.jsDir}/${config.dist.jsName}`)
    .pipe(sourcemaps.init())
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.dist.jsDir)),
);
