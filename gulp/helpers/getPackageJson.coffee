# returns parsed package.json

fs = require 'fs'
path = require 'path'

module.exports = () ->
  pak = path.join(__dirname, '..', '..', 'package.json')
  JSON.parse fs.readFileSync(pak, 'utf8')
