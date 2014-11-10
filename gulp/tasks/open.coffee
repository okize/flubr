# open app in default browser

gulp = require 'gulp'
open = require 'gulp-open'

gulp.task 'open', ->
  gulp
    .src('./src/app.coffee')
    .pipe(open('', url: 'http://127.0.0.1:' + (process.env.PORT or 3333)))
