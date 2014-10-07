# modules
fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
_ = require 'lodash'
gutil = require 'gulp-util'
liveReload = require('tiny-lr')()
nodemon = require 'gulp-nodemon'
stylus = require 'gulp-stylus'
nib = require 'nib'
mocha = require 'gulp-mocha'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
csslint = require 'gulp-csslint'
clean = require 'gulp-rimraf'
open = require 'gulp-open'
run = require 'gulp-run'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglifyjs'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
runSequence = require 'run-sequence'
mkdirp = require 'mkdirp'
bg = require 'gulp-bg'
semver = require 'semver'
moment = require 'moment'
codename = require('codename')()
exec = require 'gulp-exec'
git = require 'gulp-git'
gift = require 'gift'
repo = gift './'
mongoose = require 'mongoose'

# configuration
appRoot = __dirname
Image = require path.join(appRoot, 'src', 'models', 'image')
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
  tests: 'test/**/*.coffee'
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

# parse mongodb connection url
parseMongoUrl = (url) ->
  prefix = 'mongodb://'
  unless url.indexOf(prefix) is 0
    throw Error('Invalid mongodb URL')
  url = url.replace(prefix, '')
  parsed = {}

  # get database
  split = url.split('/')
  url = split[0]
  parsed.database = split[1]

  # get username & password
  split = url.split('@')
  if split.length > 1
    url = split[1]
    split = split[0].split(':')
    parsed.username = split[0]
    parsed.password = split[1]

  # get host & port
  split = url.split(':')
  parsed.host = split[0]
  parsed.port = split[1]

  # return parsed mongodb url
  parsed

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

# runs tests
gulp.task 'test', ->
  gulp.src(sources.tests,
    read: false
  ).pipe mocha(reporter: 'spec')

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

# commits, tags & pushes master
gulp.task 'release', (callback) ->
  runSequence(
    'commit-updates',
    'tag-version',
    'push-updates',
    callback
  )

# run a node debugger
gulp.task 'debug', ->
  bg('./node_modules/.bin/node-debug', appScript)

# download production db and import to localdb (logout first)
gulp.task 'refresh-db', ->
  devDb = parseMongoUrl env.MONGODB_DEV_URL
  prodDb = parseMongoUrl env.MONGODB_PROD_URL
  dateStamp = moment().format('YYYYMMDD-hhmmss')
  dumpDir = appRoot + '/dump/' + dateStamp
  mkdirp(dumpDir, (err) ->
    throw err if err
    run("
      mongodump --host #{prodDb.host}:#{prodDb.port}
      --db #{prodDb.database} -u #{prodDb.username}
      -p#{prodDb.password} -o #{dumpDir}
    ")
    .exec( ->
      run("
        mongorestore --drop -d #{devDb.database} #{dumpDir}/#{devDb.database}
      ").exec( ->
        log 'database downloaded from production and imported to development'
      )
    )
  )

# output some stats about image data
gulp.task 'stats', ->
  mongoose.connect env.MONGODB_PROD_URL, (err) ->
    throw err if err
    Image.find(deleted: false).exec(
      (err, results) ->
        throw err if err
        passImageCount = 0
        failImageCount = 0
        images = _.map results, (image) ->
          passImageCount++ if image.kind == 'pass'
          failImageCount++ if image.kind == 'fail'
        totalImageCount = passImageCount + failImageCount
        passPercent = ((passImageCount / totalImageCount) * 100).toFixed(1)
        failPercent = ((failImageCount / totalImageCount) * 100).toFixed(1)
        log ""
        log "   __  _         _"
        log "  / _|| |       | |"
        log " | |_ | | _   _ | |__   _ __"
        log " |  _|| || | | || '_ \\ | '__|"
        log " | |  | || |_| || |_) || |"
        log " |_|  |_| \\__,_||_.__/ |_|"
        log ""
        log "#{totalImageCount} total images"
        log "#{passImageCount} (#{passPercent}%) PASS images"
        log "#{failImageCount} (#{failPercent}%) FAIL images"
        log ""
        mongoose.disconnect()
    )

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
  if env.NODE_ENV is 'development'
    debugArgs = ['--nodejs', '--debug=5858']
    nodemon(
      script: appScript
      ext: 'coffee'
      env: env
      nodeArgs: debugArgs
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
  else if env.NODE_ENV is 'production'
    logErr 'Cannot start application.'
  else
    logErr 'Cannot start application.\nMake sure NODE_ENV is defined as either "development" or "production".'
    throw new Error('Can\'t start app')

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
      'bulletproof-font-face': false
      'adjoining-classes': false
      'font-faces': false
      'gradients': false
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
      'known-properties': false
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
        nib()
      ]
    ))
    .pipe(gulp.dest(cssBuild))

# builds the front-end javascript
gulp.task 'build-js', ->
  browserify(
      extensions: ['.coffee']
      debug: true
    )
    .add(publicScript)
    .transform(coffeeify)
    .bundle()
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
      log "#{msg} & committed to master"

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
        log "Tagged version #{pak.version}"
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

