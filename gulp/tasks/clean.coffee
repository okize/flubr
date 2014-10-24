# removes distribution folder

path = require 'path'
gulp = require 'gulp'
clean = require 'gulp-rimraf'

config = require '../config'

gulp.task 'clean', ->
  dirsToDelete = [config.dist.appDir, config.dist.cssDir, config.dist.jsDir]
  gulp
    .src(dirsToDelete, read: false)
    .pipe(clean())
