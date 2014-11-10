# starts up LiveReload server and the app with nodemon & mongo db

gulp = require 'gulp'
bg = require 'gulp-bg'
nodemon = require 'gulp-nodemon'
liveReload = require('tiny-lr')()
config = require '../config'
log = require '../helpers/log'

# starts up mongo
gulp.task 'start-mongo', bg('mongod', '--quiet')

# starts up application
gulp.task 'start-app', ->
  log.info 'Starting application server'
  nodemon(
    script: config.main
    ext: 'coffee'
    env: process.env
    nodeArgs: ['--nodejs', "--debug=#{process.env.DEBUG_PORT or 5858}"]
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
