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
open = require 'gulp-open'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglify'

# configuration
appRoot = __dirname
mainScript = path.join(appRoot, 'src', 'app.coffee')
appBuild = path.join(appRoot, 'build')
cssBuild = path.join(appRoot, 'public', 'stylesheets')
jsBuild = path.join(appRoot, 'public', 'javascripts')
sources =
  app: 'src/**/*.coffee'
  stylus: 'views/stylesheets/*.styl'
  coffee: 'views/javascripts/*.coffee'
  jade: 'views/*.jade'
compiled =
  css: 'public/stylesheets/styles.css'
  js: 'public/javascripts/scripts.js'
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
    ignore: ['node_modules/', 'views/', 'build/', 'public', 'gulp*']
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
  gulp
    .watch(getSources(), refresh)

# open app in default browser
gulp.task 'open', ->
  port = process.env.PORT or 3333
  gulp
    .src('./src/app.coffee')
    .pipe(open('', url: "http://127.0.0.1:#{port}"))

# removes distribution folder
gulp.task 'clean', ->
  gulp
    .src(appBuild, read: false)
    .pipe(clean())

# minifies js
gulp.task 'coffeemin', ->
  gulp.src(compiled.js)
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(gulp.dest(jsBuild))

# lints coffeescript
gulp.task 'coffeelint', ->
  gulp
    .src([sources.app, sources.coffee])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

# minifies css
gulp.task 'cssmin', ->
  gulp
    .src(compiled.css)
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(gulp.dest(cssBuild))

# lints css
gulp.task 'csslint', ->
  gulp
    .src([compiled.css])
    .pipe(csslint())
    .pipe(csslint.reporter())

# builds coffeescript source into deployable javascript
gulp.task 'build', ->
  gulp
    .src(sources.app)
    .pipe(coffee(
      bare: true
      sourceMap: false
    ).on('error', gutil.log))
    .pipe(
      gulp.dest(appBuild)
    )

# deploys application
gulp.task 'deploy', [
  'clean'
  'build'
  'coffeemin'
  'cssmin'
]
