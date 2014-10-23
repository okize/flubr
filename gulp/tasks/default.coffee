# default task that's run with 'gulp'

gulp = require 'gulp'
runSequence = require 'run-sequence'

gulp.task 'default', (callback) ->
  runSequence(
    'start-mongo',
    'start-app',
    'watch',
    callback
  )
