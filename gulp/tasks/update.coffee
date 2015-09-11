# checks for outdatd modules

gulp = require 'gulp'
_ = require 'lodash'
run = require 'gulp-run'
ncu = require 'npm-check-updates'
Table = require 'cli-table'
getPak = require '../helpers/getPackageJson'

gulp.task 'update', ->
  ncu
    .run packageData: getPak()
    .then (upgraded) ->
      table = new Table
      _.each upgraded, (v, k) -> table.push [k, v]
      console.log 'Dependencies that should be upgraded: \n\n', table.toString()
