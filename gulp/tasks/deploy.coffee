# deploys app to heroku

gulp = require 'gulp'
git = require 'gulp-git'

log = require '../helpers/log'
getPak = require '../helpers/getPackageJson'

gulp.task 'deploy-app', ->

  pak = getPak()

  git
    .push(
      'heroku',
      'master',
      null,
      ->
        log.info "Pushed v#{pak.version} to Heroku"
    )
    .end()
