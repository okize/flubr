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
    .src(config.src.app)
    .pipe(coffee(
      bare: true
      sourceMap: false
    ).on('error', gutil.log))
    .pipe(
      gulp.dest(config.dist.appDir)
    )

# builds the css
gulp.task 'build-css', ->
  gulp
    .src("#{config.src.stylusDir}#{config.src.stylusEntry}")
    .pipe(stylus(
      linenos: false
      use: [
        nib()
      ]
    ))
    .pipe(gulp.dest(config.dist.cssDir))

# builds the front-end javascript
gulp.task 'build-js', ->
  browserify(
      extensions: ['.coffee']
      debug: true
    )
    .add("#{config.src.coffeeDir}#{config.src.coffeeEntry}")
    .transform(coffeeify)
    .bundle()
    .on('error', gutil.log)
    .pipe(source('scripts.js'))
    .pipe(gulp.dest(config.dist.jsDir))
