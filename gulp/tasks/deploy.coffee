# deploys app to heroku

gulp = require 'gulp'
git = require 'gulp-git'
log = require '../helpers/log'

gulp.task 'deploy-app', ->

  pak = require('../helpers/getPackageJson')()

  git
    .push(
      'heroku',
      'master',
      null,
      ->
        log.info "Pushed v#{pak.version} to Heroku"
    )
    .end()
