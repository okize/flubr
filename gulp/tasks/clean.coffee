# removes distribution folder

path = require 'path'
gulp = require 'gulp'
clean = require 'del'

config = require '../config'

gulp.task 'clean', ->
  clean [config.dist.appDir, config.dist.cssDir, config.dist.jsDir]
