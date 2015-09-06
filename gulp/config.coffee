# configuration file for Gulp tasks

path = require 'path'
root = path.resolve(__dirname, '..')
assets = path.resolve(root, 'public')
coffeeDir = "#{root}/views/javascripts/"
stylusDir = "#{root}/views/stylesheets/"

module.exports =
  root: root
  tests: "#{root}/tests/**/*.coffee"
  taskDir: "#{root}/gulp/tasks/"
  main: "#{root}/src/app.coffee"

  # DO NOT restart node app when files change in these directories
  appIgnoreDirs: [
    '.git',
    'node_modules/**/node_modules',
    'gulp/**',
    'views/**',
    'tests/**'
  ]

  # asset sources
  src:
    app: "#{root}/src/**/*.coffee"
    favicons: "#{root}/assets/favicons/"
    jade: "#{root}/views/**/**/*.jade"
    stylus: "#{stylusDir}**/*.styl"
    stylusEntry: 'styles.styl'
    stylusDir: stylusDir
    coffee: "#{coffeeDir}*.coffee"
    coffeeEntry: 'scripts.coffee'
    coffeeDir: coffeeDir

  # asset compilation targets
  dist:
    appDir: "#{root}/build/"
    cssName: 'styles.css'
    cssDir: "#{assets}/stylesheets/"
    jsName: 'scripts.js'
    jsDir: "#{assets}/javascripts/"
