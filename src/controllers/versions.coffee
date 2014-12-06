path = require 'path'
request = require 'request'
pak = require path.join('..', '..', 'package.json')

module.exports =

  getLocalVersion: (req, res) ->
    res.send pak.version

  getRemoteVersion: (req, res) ->
    GITHUB_PAK_URL = 'https://raw.githubusercontent.com/okize/flubr/master/package.json'
    request GITHUB_PAK_URL, (error, response, body) ->
      if not error and response.statusCode is 200
        res.send JSON.parse(body).version
      else
        console.error error
        res.send null
