# watches source files and triggers a page refresh on change

path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
_ = require 'lodash'
liveReload = require('tiny-lr')()
config = require '../config'
log = require '../helpers/log'

config = require '../config'

sources =
  app: 'src/**/*.coffee'
  stylus: 'views/stylesheets/*.styl'
  coffee: 'views/javascripts/*.coffee'
  jade: 'views/**/*.jade'
  tests: 'test/**/*.coffee'

# returns an array of the source folders in sources object
getSources = ->
  _.values sources

# sends updated files to LiveReload server
refreshPage = (event) ->
  fileName = path.relative(config.root, event.path)
  gutil.log.apply gutil, [gutil.colors.blue(fileName + ' changed')]
  liveReload.changed body:
    files: [fileName]

gulp.task 'watch', ->
  gulp
    .watch(getSources(), refreshPage)
