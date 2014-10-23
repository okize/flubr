# creates a build

path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
source = require 'vinyl-source-stream'
runSequence = require 'run-sequence'
rename = require 'gulp-rename'
coffee = require 'gulp-coffee'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
stylus = require 'gulp-stylus'
nib = require 'nib'

config = require '../config'

sources =
  app: 'src/**/*.coffee'
appBuild = path.join(config.root, 'build')
cssBuild = path.join(config.root, 'public', 'stylesheets')
jsBuild = path.join(config.root, 'public', 'javascripts')
publicCss = path.join(config.root, 'views', 'stylesheets', 'styles.styl')
publicScript = path.join(config.root, 'views', 'javascripts', 'scripts.coffee')

gulp.task 'build', (callback) ->
  runSequence(
    ['clean'],
    ['build-css', 'build-js', 'build-app'],
    ['minify-css', 'minify-js']
    callback
  )

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
