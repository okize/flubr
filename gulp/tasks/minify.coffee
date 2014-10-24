# minifies css & js

path = require 'path'
gulp = require 'gulp'
rename = require 'gulp-rename'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglifyjs'

config = require '../config'

gulp.task 'minify', [
  'minify-css',
  'minify-js'
]

gulp.task 'minify-css', ->
  gulp
    .src("#{config.dist.cssDir}/#{config.dist.cssName}")
    .pipe(minifyCss())
    .pipe(rename('styles.min.css'))
    .pipe(gulp.dest(config.dist.cssDir))

gulp.task 'minify-js', ->
  gulp
    .src("#{config.dist.jsDir}/#{config.dist.jsName}")
    .pipe(uglify())
    .pipe(rename('scripts.min.js'))
    .pipe(gulp.dest(config.dist.jsDir))
