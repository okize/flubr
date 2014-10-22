# allow only .coffee and .js files to prevent
# accidental inclusion of other file types

path = require 'path'

module.exports = (name) ->
  /(\.(js|coffee)$)/i.test path.extname(name)
