# open app in default browser

gulp = require 'gulp'
open = require 'gulp-open'

env = require('../helpers/getEnvironmentVariables')()

gulp.task 'open', ->
  gulp
    .src('./src/app.coffee')
    .pipe(open('', url: 'http://127.0.0.1:' + (env.PORT or 3333)))
