# returns a filtered list of all the scripts in tasks dir (js & coffee only)

fs = require 'fs'
config = require '../config'
isScript = require '../helpers/isScript'

module.exports = () ->
  fs.readdirSync(config.taskDir).filter(isScript)
