# modules
path = require 'path'
_ = require 'lodash'
gulp = require 'gulp'
gutil = require 'gulp-util'
liveReload = require('tiny-lr')()
nodemon = require 'gulp-nodemon'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
csslint = require 'gulp-csslint'
clean = require 'gulp-clean'
bump = require 'gulp-bump'

# configuration
appRoot = __dirname
mainScript = path.join(appRoot, 'src', 'app.coffee')
buildDir = path.join(appRoot, 'build')
sources =
  app: 'src/**/*.coffee'
  stylus: 'views/stylesheets/*.styl'
  coffee: 'views/javascripts/*.coffee'
compiled =
  css: 'public/stylesheets/*.css'
  js: 'public/javascripts/*.js'
liveReloadPort = 35730

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

# compiles css
gulp.task 'css', ->
  console.log 'compile css'

# compiles js
gulp.task 'js', ->
  console.log 'compile javascript'

# lints coffeescript
gulp.task 'coffeelint', ->
  gulp
    .src([sources.app, sources.coffee])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

# lints css
gulp.task 'csslint', ->
  gulp
    .src([compiled.css])
    .pipe(csslint())
    .pipe(csslint.reporter())

gulp.task 'bump version', ->
  gulp
    .src('./package.json')
    .pipe(bump(type: 'patch'))
    .pipe gulp.dest('./')

# builds application coffeescript into deployable javascript
gulp.task 'build app', ->
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
  'build app',
  'bump version'
]

# default task that's run with 'gulp'
gulp.task 'default', [
  'start',
  'watch'
]