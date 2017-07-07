// lints coffeescript & css

const gulp = require('gulp');
const coffeelint = require('gulp-coffeelint');
const csslint = require('gulp-csslint');

const config = require('../config');
const log = require('../helpers/log');

gulp.task('lint', [
  'lint-coffeescript',
  'lint-css',
]);

gulp.task('lint-coffeescript', () =>
  gulp
    .src([config.src.app, config.src.coffee])
    .pipe(
      coffeelint(`${config.root}/.coffeelintrc`).on('error', log.error),
    )
    .pipe(coffeelint.reporter()),
);

gulp.task('lint-css', () =>
  gulp
    .src(`${config.dist.cssDir}/${config.dist.cssName}`)
    .pipe(
      csslint({
        'bulletproof-font-face': false,
        'adjoining-classes': false,
        'font-faces': false,
        gradients: false,
        'box-sizing': false,
        'universal-selector': false,
        'box-model': false,
        'overqualified-elements': false,
        'compatible-vendor-prefixes': false,
        'unique-headings': false,
        'qualified-headings': false,
        'unqualified-attributes': false,
        important: false,
        'outline-none': false,
        shorthand: false,
        'font-sizes': false,
        'known-properties': false,
      }).on('error', log.error),
    )
    .pipe(csslint.reporter()),
);
