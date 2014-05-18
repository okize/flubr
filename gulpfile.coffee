appRoot = __dirname
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
nodemon = require 'gulp-nodemon'
liveReload = require('tiny-lr')()
liveReloadPort = 35729

log = (msg) ->
  gutil.log '[gulpfile]', gutil.colors.blue(msg)

sources = ['src/*.coffee', 'views/*.jade','views/stylesheets/*.styl']

refresh = (event) ->
  fileName = path.relative appRoot, event.path
  gutil.log.apply gutil, [gutil.colors.blue(fileName + ' changed')]
  liveReload.changed body:
    files: [fileName]

# default task that's run with 'gulp'
gulp.task 'default', [
  'start',
  'watch'
]

# starts up LiveReload server and the app with nodemon
gulp.task 'start', ->
  nodemon(
    script: path.join appRoot, 'src/app.coffee'
    ext: 'coffee'
    ignore: ['node_modules/']
  ).on('restart', (files) ->
    if files? && files.length?
      log 'app restarted because of modifications to: ', files
  ).on('start', ->
    log 'app started'
    liveReload.listen liveReloadPort
  ).on('quit', ->
    log 'app closed'
    liveReload.close()
    gutil.beep()
  )

# watches source files and triggers refresh on change
gulp.task 'watch', ->
  log 'watching files!'
  gulp.watch sources, refresh
