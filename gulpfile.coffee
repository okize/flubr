# modules
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
nodemon = require 'gulp-nodemon'
coffee = require 'gulp-coffee'
liveReload = require('tiny-lr')()

# configuration
appRoot = __dirname
liveReloadPort = 35729

# small wrapper around gulp util logging
log = (msg) ->
  gutil.log '[gulpfile]', gutil.colors.blue(msg)

# list of folders that need to be compiled
sources =
  app: 'src/*.*'
  jade: 'views/*.jade'
  css: 'views/stylesheets/*.styl'

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
    script: path.join(appRoot, 'src/app.coffee')
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
  gulp.watch ['src/*.coffee', 'views/*.jade','views/stylesheets/*.styl'], refresh

# builds coffeescript source into deployable javascript
gulp.task 'build', ->
  gulp
    .src(sources.app)
    .pipe(coffee(
      bare: true
      sourceMap: true
    ).on('error', gutil.log))
    .pipe(gulp.dest(path.join(appRoot, 'dist')))

# deploys application
gulp.task 'deploy', ->
  log 'todo!'