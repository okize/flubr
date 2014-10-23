# minifies css & js

path = require 'path'
gulp = require 'gulp'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglifyjs'

config = require '../config'

cssBuild = path.join(config.root, 'public', 'stylesheets')
jsBuild = path.join(config.root, 'public', 'javascripts')

compiled =
  css: "#{cssBuild}/styles.css"
  js: "#{jsBuild}/scripts.js"

gulp.task 'minify', [
  'minify-css',
  'minify-js'
]

gulp.task 'minify-css', ->
  gulp
    .src(compiled.css)
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(gulp.dest(cssBuild))

gulp.task 'minify-js', ->
  gulp
    .src(compiled.js)
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(gulp.dest(jsBuild))
