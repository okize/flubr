# loads environment variables

fs = require 'fs'

module.exports = ->
  envJson = 'env.json'
  if fs.existsSync envJson
    JSON.parse(fs.readFileSync envJson, 'utf8')
  else
    logErr 'missing Environment Variables! please create an env.json'
    throw new Error 'MISSING ENV VARS'
