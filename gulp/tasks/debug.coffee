# run a node debugger

gulp = require 'gulp'
bg = require 'gulp-bg'

config = require '../config'

gulp.task 'debug', ->
  bg('./node_modules/.bin/node-debug', config.main)
