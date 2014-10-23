# configuration file for Gulp tasks

path = require 'path'
root = path.resolve(__dirname, '..')
assets = path.resolve(root, 'public')

module.exports =
  root: root
  tests: "#{root}/tests/**/*.coffee"
  taskDir: "#{root}/gulp/tasks"
  main: "#{root}/src/app.coffee"
  publicAssetsDir: assets

  # DO NOT restart node app when files change in these directories
  appIgnoreDirs: [
    'node_modules',
    'gulp',
    'views',
    'tests'
  ]

  # asset sources
  src:
    favicons: "#{root}/assets/favicons/"
    sassEntry: 'main.sass'
    sassDir: "#{root}/assets/sass/"
    coffeeEntry: 'app.coffee'
    coffeeDir: "#{root}/assets/coffee/"

  # asset compilation targets
  dist:
    cssName: 'styles.css'
    cssDir: "#{assets}/stylesheets"
    jsName: 'scripts.js'
    jsDir: "#{assets}/javascripts"
