# watches source files and triggers a page refresh on change

path = require 'path'
gulp = require 'gulp'
_ = require 'lodash'
liveReload = require('tiny-lr')()

config = require '../config'
log = require '../helpers/log'

# sends updated files to LiveReload server
refreshPage = (event) ->
  fileName = path.relative(config.root, event.path)
  log.info "#{fileName} changed"
  liveReload.changed body:
    files: [fileName]

gulp.task 'watch', ->
  dirsToWatch = [
    config.src.app
    config.src.jade
    config.src.stylus
    config.src.coffee
  ]
  gulp
    .watch(dirsToWatch, refreshPage)
