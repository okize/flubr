# commits, tags & pushes master

fs = require 'fs'
gulp = require 'gulp'
runSequence = require 'run-sequence'
semver = require 'semver'
codename = require('codename')()
git = require 'gulp-git'
gift = require 'gift'
repo = gift './'

config = require '../config'

gulp.task 'release', (callback) ->
  runSequence(
    ['commit-updates'],
    ['tag-version'],
    ['push-updates'],
    callback
  )

# commit updated files
gulp.task 'commit-updates', ->

  pak = require('../helpers/getPackageJson')()

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
      log.info "#{msg} & committed to master"

# bumps patch version and creates a new tag
gulp.task 'tag-version', ->

  pak = require('../helpers/getPackageJson')()

  # creates new tag
  git
    .tag(
      'v' + pak.version,
      'Release codename: ' + pak.releaseCodename,
      args: ' --annotate',
      ->
        log.info "Tagged version #{pak.version}"
    )

# push commits to github
gulp.task 'push-updates', ->

  pak = require('../helpers/getPackageJson')()

  git
    .push(
      'origin',
      'master',
      args: ' --tags',
      ->
        log.info "Pushed v#{pak.version} tag to Github"
    )
    .end()
