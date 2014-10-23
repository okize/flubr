# lints coffeescript & css

gulp = require 'gulp'
gutil = require 'gulp-util'
coffeelint = require 'gulp-coffeelint'
csslint = require 'gulp-csslint'
config = require '../config'
env = require('../helpers/getEnvironmentVariables')()
log = require '../helpers/log'

sources =
  app: 'src/**/*.coffee'
  stylus: 'views/stylesheets/*.styl'
  coffee: 'views/javascripts/*.coffee'

compiled =
  css: 'public/stylesheets/styles.css'
  js: 'public/javascripts/scripts.js'

gulp.task 'lint', [
  'lint-coffeescript',
  'lint-css'
]

gulp.task 'lint-coffeescript', ->
  gulp
    .src([sources.app, sources.coffee])
    .pipe(coffeelint().on('error', gutil.log))
    .pipe(coffeelint.reporter())

gulp.task 'lint-css', ->
  gulp
    .src(compiled.css)
    .pipe(
      csslint(
        'bulletproof-font-face': false
        'adjoining-classes': false
        'font-faces': false
        'gradients': false
        'box-sizing': false
        'universal-selector': false
        'box-model': false
        'overqualified-elements': false
        'compatible-vendor-prefixes': false
        'unique-headings': false
        'qualified-headings': false
        'unqualified-attributes': false
        'important': false
        'outline-none': false
        'shorthand': false
        'font-sizes': false
        'known-properties': false
      ).on('error', gutil.log)
    )
    .pipe(csslint.reporter())
