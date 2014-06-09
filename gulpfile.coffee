# modules
path = require 'path'
_ = require 'lodash'
gulp = require 'gulp'
gutil = require 'gulp-util'
liveReload = require('tiny-lr')()
nodemon = require 'gulp-nodemon'
stylus = require 'gulp-stylus'
axis = require 'axis-css'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
csslint = require 'gulp-csslint'
clean = require 'gulp-clean'
bump = require 'gulp-bump'
open = require 'gulp-open'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglify'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'

# configuration
appRoot = __dirname
appScript = path.join(appRoot, 'src', 'app.coffee')
publicScript = path.join(appRoot, 'views', 'javascripts', 'scripts.coffee')
publicCss = path.join(appRoot, 'views', 'stylesheets', 'styles.styl')
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
liveReloadPort = process.env.LIVE_RELOAD_PORT or 35729

# returns an array of the source folders in sources object
getSources = ->
  _.values sources

# info logging
log = (msg) ->
  gutil.log '[gulpfile]', gutil.colors.blue(msg)

# sends updated files to LiveReload server
refreshPage = (event) ->
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
    script: appScript
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

# watches source files and triggers a page refresh on change
gulp.task 'watch', ->
  log 'watching files...'
  gulp
    .watch(getSources(), refreshPage)

# open app in default browser
gulp.task 'open', ->
  port = process.env.PORT or 3333
  gulp
    .src('./src/app.coffee')
    .pipe(open('', url: 'http://127.0.0.1:' + port))

# removes distribution folder
gulp.task 'clean-directories', ->
  gulp
    .src([appBuild, cssBuild, jsBuild], read: false)
    .pipe(clean())

# minifies js
gulp.task 'minify-js', ->
  gulp.src(compiled.js)
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(gulp.dest(jsBuild))

# minifies css
gulp.task 'minify-css', ->
  gulp
    .src(compiled.css)
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(gulp.dest(cssBuild))

# lints coffeescript
gulp.task 'coffeelint', ->
  gulp
    .src([sources.app, sources.coffee])
    .pipe(coffeelint().on('error', gutil.log))
    .pipe(coffeelint.reporter())

# lints css
gulp.task 'csslint', ->
  gulp
    .src(compiled.css)
    .pipe(csslint(
      'box-sizing': false
      'universal-selector': false
      'box-model': false
      'overqualified-elements': false
      'compatible-vendor-prefixes': false
      'unique-headings': false
      'qualified-headings': false
      'unqualified-attributes': false
      'important': false
      'outline-none': false
      'shorthand': false
      'font-sizes': false
    ).on('error', gutil.log))
    .pipe(csslint.reporter())

# lints coffeescript & css
gulp.task 'lint', [
  'coffeelint',
  'csslint'
]

# bumps patch version for every release
gulp.task 'bump-version', ->
  gulp
    .src('./package.json')
    .pipe(bump(type: 'patch'))
    .pipe gulp.dest('./')

# builds the css
gulp.task 'build-css', ->
  gulp
    .src(publicCss)
    .pipe(stylus(
      linenos: false
      use: [
        axis(implicit: false)
      ]
    ))
    .pipe(gulp.dest(cssBuild))

# builds the front-end javascript
gulp.task 'build-js', ->
  browserify(
      extensions: ['.coffee']
    )
    .add(publicScript)
    .transform(coffeeify)
    .bundle(debug: true)
    .on('error', gutil.log)
    .pipe(source('scripts.js'))
    .pipe(gulp.dest(jsBuild))

# builds coffeescript source into deployable javascript
gulp.task 'build-app', ->
  gulp
    .src(sources.app)
    .pipe(coffee(
      bare: true
      sourceMap: false
    ).on('error', gutil.log))
    .pipe(
      gulp.dest(appBuild)
    )

# deploys app to heroku
gulp.task 'deploy-app', ->
  console.log 'deploy'

# creates a release and deploys the application
gulp.task 'release', [
  'clean-directories',
  'build-css',
  'build-js',
  'build-app',
  'minify-js',
  'minify-css',
  'bump-version',
  'deploy-app'
]
