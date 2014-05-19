# modules
path = require 'path'
_ = require 'lodash'
gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
liveReload = require('tiny-lr')()
nodemon = require 'gulp-nodemon'
coffee = require 'gulp-coffee'
clean = require 'gulp-clean'

# configuration
appRoot = __dirname
mainScript = path.join(appRoot, 'src', 'app.coffee')
buildDir = path.join(appRoot, 'build')
sources =
  app: 'src/**/*.coffee'
  jade: 'views/*.jade'
  css: 'views/stylesheets/*.styl'
  coffee: 'views/javascripts/*.coffee'
liveReloadPort = 35729


# returns an array of the source folders in sources object
getSources = ->
  _.values sources

# small wrapper around gulp util logging
log = (msg) ->
  gutil.log '[gulpfile]', gutil.colors.blue(msg)

# sends updated files to LiveReload server
refresh = (event) ->
  fileName = path.relative(appRoot, event.path)
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
    script: mainScript
    ext: 'coffee'
    env:
      'NODE_ENV': 'development'
    ignore: ['node_modules/']
  ).on('restart', (files) ->
    log 'app restarted'
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
  log 'watching files...'
  gulp.watch getSources(), refresh

# removes distribution folder
gulp.task 'clean', ->
  gulp
    .src(buildDir, read: false)
    .pipe(clean())

# builds coffeescript source into deployable javascript
gulp.task 'build', ->
  gulp
    .src(sources.app)
    .pipe(coffee(
      bare: true
      sourceMap: false
    ).on('error', gutil.log))
    .pipe(
      gulp.dest(buildDir)
    )

# deploys application
gulp.task 'deploy', [
  'clean',
  'build'
]
