# checks for outdatd modules

gulp = require 'gulp'
run = require 'gulp-run'
ncu = require 'npm-check-updates'
getPak = require '../helpers/getPackageJson'

gulp.task 'update', ->
  ncu
    .run packageData: getPak()
    .then (upgraded) ->
      console.log 'Dependencies that should be upgraded: \n\n', upgraded
