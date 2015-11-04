# starts up LiveReload server and the app with nodemon & mongo db

path = require 'path'
gulp = require 'gulp'
bg = require 'gulp-bg'
nodemon = require 'gulp-nodemon'
liveReload = require('tiny-lr')()
config = require '../config'
log = require '../helpers/log'

# sends updated files to LiveReload server
refreshPage = (event) ->
  fileName = path.relative(config.root, event.path)
  log.info "#{fileName} changed"
  liveReload.changed body:
    files: [fileName]

# watches source files and triggers a page refresh on change
gulp.task 'watch', ->
  dirsToWatch = [
    config.src.app
    config.src.jade
    config.src.stylus
    config.src.coffee
  ]
  gulp
    .watch(dirsToWatch, refreshPage)

# starts up mongo
gulp.task 'start-mongo', bg('mongod', '--quiet')

# starts up application
gulp.task 'start-app', ->
  log.info 'Starting application server'
  nodemon(
    script: config.main
    env: process.env
    nodeArgs: ["--debug=#{process.env.DEBUG_PORT or 5858}"]
    ignore: config.appIgnoreDirs
  ).on('restart', (files) ->
    log.info 'app restarted'
  ).on('start', ->
    liveReloadPort = process.env.LIVE_RELOAD_PORT or 35729
    liveReload.listen liveReloadPort
    log.info 'livereload started on port ' + liveReloadPort
  ).on('quit', ->
    log.info 'app closed'
    liveReload.close()
    gutil.beep()
  )
