# starts up LiveReload server and the app with nodemon & mongo db

gulp = require 'gulp'
bg = require 'gulp-bg'
nodemon = require 'gulp-nodemon'
liveReload = require('tiny-lr')()
config = require '../config'
env = require('../helpers/getEnvironmentVariables')()
log = require '../helpers/log'

# starts up mongo
gulp.task 'start-mongo',
  bg('mongod', '--quiet')

gulp.task 'start-app', ->
  if env.NODE_ENV is 'development'
    nodemon(
      script: config.main
      ext: 'coffee'
      env: env
      nodeArgs: ['--nodejs', '--debug=5858']
      ignore: [
        'node_modules/',
        'views/',
        'build/',
        'public/'
      ]
    ).on('restart', (files) ->
      log.info 'app restarted'
    ).on('start', ->
      liveReloadPort = env.LIVE_RELOAD_PORT or 35729
      liveReload.listen liveReloadPort
      log.info 'livereload started on port ' + liveReloadPort
    ).on('quit', ->
      log.info 'app closed'
      liveReload.close()
      gutil.beep()
    )
  else if env.NODE_ENV is 'production'
    nodemon(
      script: config.main
      env: env
      nodeArgs: ['--nodejs', '--debug=5858']
      ignore: [
        'node_modules/',
        'views/',
        'build/',
        'public/'
      ]
    ).on('restart', (files) ->
      log.info 'app restarted'
    ).on('quit', ->
      log.info 'app closed'
      liveReload.close()
      gutil.beep()
    )
  else
    log.error 'Cannot start application.\nMake sure NODE_ENV is defined as either "development" or "production".'
    throw new Error('Can\'t start app')
