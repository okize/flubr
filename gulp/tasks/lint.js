const gulp = require('gulp');
const csslint = require('gulp-csslint');
const config = require('../config');
const log = require('../helpers/log');

const cssLintConfig = {
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
};

// lint css
gulp.task('lint', () => {
  return gulp
    .src(`${config.dist.cssDir}/${config.dist.cssName}`)
    .pipe(csslint(cssLintConfig).on('error', log.error))
    .pipe(csslint.reporter());
});
