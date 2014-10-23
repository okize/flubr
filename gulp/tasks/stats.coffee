# output some stats about image data

path = require 'path'
gulp = require 'gulp'
_ = require 'lodash'
config = require '../config'
env = require('../helpers/getEnvironmentVariables')()
log = require '../helpers/log'
Image = require "#{config.root}/src/models/image"
mongoose = require 'mongoose'

gulp.task 'stats', ->
  mongoose.connect env.MONGODB_PROD_URL || env.MONGOHQ_URL, (err) ->
    throw err if err
    Image.find(deleted: false).exec(
      (err, results) ->
        throw err if err
        passImageCount = 0
        failImageCount = 0
        images = _.map results, (image) ->
          passImageCount++ if image.kind == 'pass'
          failImageCount++ if image.kind == 'fail'
        totalImageCount = passImageCount + failImageCount
        passPercent = ((passImageCount / totalImageCount) * 100).toFixed(1)
        failPercent = ((failImageCount / totalImageCount) * 100).toFixed(1)
        log.logo()
        log.info "#{totalImageCount} total images"
        log.info "#{passImageCount} (#{passPercent}%) PASS images"
        log.info "#{failImageCount} (#{failPercent}%) FAIL images"
        mongoose.disconnect()
    )
