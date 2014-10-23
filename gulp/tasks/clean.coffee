# removes distribution folder

path = require 'path'
gulp = require 'gulp'
clean = require 'gulp-rimraf'

config = require '../config'

appBuild = path.join(config.root, 'build')
cssBuild = path.join(config.root, 'public', 'stylesheets')
jsBuild = path.join(config.root, 'public', 'javascripts')

gulp.task 'clean', ->
  gulp
    .src([appBuild, cssBuild, jsBuild], read: false)
    .pipe(clean())
