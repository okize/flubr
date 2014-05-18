gulp = require 'gulp'
nodemon = require 'gulp-nodemon'

gulp.task 'default', ->
  nodemon(
    script: './src/app.coffee'
    ext: 'coffee'
    ignore: ['node_modules/*']
  ).on('restart', (files) ->
    console.log 'app restarted because: ', files
  ).on('start', ->
    console.log 'app started!'
  ).on('quit', ->
    console.log 'app quit!'
  )
