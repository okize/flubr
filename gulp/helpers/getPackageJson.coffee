# returns parsed package.json

fs = require 'fs'
path = require 'path'

module.exports = (parsed) ->
  pak = fs.readFileSync(path.join(__dirname, '..', '..', 'package.json'), 'utf8')
  if parsed then JSON.parse(pak) else pak
