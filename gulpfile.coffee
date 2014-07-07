# modules
fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
_ = require 'lodash'
gutil = require 'gulp-util'
liveReload = require('tiny-lr')()
nodemon = require 'gulp-nodemon'
stylus = require 'gulp-stylus'
axis = require 'axis-css'
rupture = require 'rupture'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
csslint = require 'gulp-csslint'
clean = require 'gulp-clean'
open = require 'gulp-open'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglifyjs'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
runSequence = require 'run-sequence'
bg = require 'gulp-bg'
semver = require 'semver'
codename = require('codename')()
exec = require 'gulp-exec'
git = require 'gulp-git'
gift = require 'gift'
repo = gift './'

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
  jade: 'views/**/*.jade'
compiled =
  css: 'public/stylesheets/styles.css'
  js: 'public/javascripts/scripts.js'

# loads environment variables
getEnvironmentVariables = ->
  envJson = 'env.json'
  if fs.existsSync envJson
    JSON.parse(fs.readFileSync envJson, 'utf8')
  else
    logErr 'missing Environment Variables! please create an env.json'
    throw new Error 'MISSING ENV VARS'

# info logging
log = (msg) ->
  gutil.log gutil.colors.blue(msg)

# error logging
logErr = (msg) ->
  gutil.log gutil.colors.red(msg)

# returns an array of the source folders in sources object
getSources = ->
  _.values sources

# sends updated files to LiveReload server
refreshPage = (event) ->
  fileName = path.relative(appRoot, event.path)
  gutil.log.apply gutil, [gutil.colors.blue(fileName + ' changed')]
  liveReload.changed body:
    files: [fileName]

# returns parsed package.json
getPackage = ->
  JSON.parse fs.readFileSync('./package.json', 'utf8')

# get environment variables
env = getEnvironmentVariables()

# default task that's run with 'gulp'
gulp.task 'default', (callback) ->
  runSequence(
    'start-mongo',
    'start-app',
    'watch-for-changes',
    callback
  )

# lints coffeescript & css
gulp.task 'lint', [
  'lint-coffeescript',
  'lint-css'
]

# creates a build
gulp.task 'build', (callback) ->
  runSequence(
    'clean-directories',
    ['build-css', 'build-js', 'build-app'],
    ['minify-css', 'minify-js']
    callback
  )

# commits, tags & deploys application
gulp.task 'release', (callback) ->
  runSequence(
    'commit-updates',
    'tag-version',
    'push-updates',
    'deploy-app',
    callback
  )

# run a node debugger
gulp.task 'debug', ->
  bg('./node_modules/.bin/node-debug', appScript)

# open app in default browser
gulp.task 'open', ->
  gulp
    .src('./src/app.coffee')
    .pipe(open('', url: 'http://127.0.0.1:' + (env.PORT or 3333)))

# starts up mongo
gulp.task 'start-mongo',
  bg('mongod', '--quiet')

# starts up LiveReload server and the app with nodemon
gulp.task 'start-app', ->
  nodemon(
    script: appScript
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
    log 'app restarted'
  ).on('start', ->
    liveReloadPort = env.LIVE_RELOAD_PORT or 35729
    liveReload.listen liveReloadPort
    log 'livereload started on port ' + liveReloadPort
  ).on('quit', ->
    log 'app closed'
    liveReload.close()
    gutil.beep()
  )

# watches source files and triggers a page refresh on change
gulp.task 'watch-for-changes', ->
  gulp
    .watch(getSources(), refreshPage)

# lints coffeescript
gulp.task 'lint-coffeescript', ->
  gulp
    .src([sources.app, sources.coffee, './gulpfile.coffee'])
    .pipe(coffeelint().on('error', gutil.log))
    .pipe(coffeelint.reporter())

# lints css
gulp.task 'lint-css', ->
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

# removes distribution folder
gulp.task 'clean-directories', ->
  gulp
    .src([appBuild, cssBuild, jsBuild], read: false)
    .pipe(clean())

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

# builds the css
gulp.task 'build-css', ->
  gulp
    .src(publicCss)
    .pipe(stylus(
      linenos: false
      use: [
        rupture(),
        axis(implicit: false)
      ]
    ))
    .pipe(gulp.dest(cssBuild))

# builds the front-end javascript
gulp.task 'build-js', ->
  browserify(extensions: ['.coffee'])
    .add(publicScript)
    .transform(coffeeify)
    .bundle(debug: true)
    .on('error', gutil.log)
    .pipe(source('scripts.js'))
    .pipe(gulp.dest(jsBuild))

# minifies css
gulp.task 'minify-css', ->
  gulp
    .src(compiled.css)
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(gulp.dest(cssBuild))

# minifies js
gulp.task 'minify-js', ->
  gulp.src(compiled.js)
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(gulp.dest(jsBuild))

# commit updated files
gulp.task 'commit-updates', ->

  pak = getPackage()

  # create a codename for app release
  pak.releaseCodename = codename.generate(
    ['alliterative', 'random'],
    ['adjectives', 'animals']
  ).join('')

  # bump patch version of app
  pak.version = semver.inc(pak.version, 'patch')
  fs.writeFileSync './package.json', JSON.stringify(pak, null, '  ')
  msg = "Built new release (v#{pak.version}) codenamed #{pak.releaseCodename}"
  repo.add './', (err) ->
    throw err if err
    repo.commit msg, {all: true}, (err) ->
      throw err if err
      log 'Commited master branch'

# bumps patch version and creates a new tag
gulp.task 'tag-version', ->

  pak = getPackage()

  # creates new tag
  git
    .tag(
      'v' + pak.version,
      'Release codename: ' + pak.releaseCodename,
      args: ' --annotate',
      ->
        log "Taged version #{pak.version} codenamed #{pak.releaseCodename}"
    )

# push commits to github
gulp.task 'push-updates', ->

  pak = getPackage()

  git
    .push(
      'origin',
      'master',
      args: ' --tags',
      ->
        log "Pushed v#{pak.version} tag to Github"
    )
    .end()

# deploys app to heroku
gulp.task 'deploy-app', ->

  pak = getPackage()

  git
    .push(
      'heroku',
      'master',
      null,
      ->
        log "Pushed v#{pak.version} to Heroku"
    )
    .end()

