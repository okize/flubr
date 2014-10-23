# runs tests

gulp = require 'gulp'
mocha = require 'gulp-mocha'
config = require '../config'

gulp.task 'test', ->
  gulp.src(config.tests,
    read: false
  ).pipe mocha(reporter: 'spec')
