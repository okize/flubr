$ = require 'jquery'
isNewer = require 'is-version-newer'

module.exports =

  getVersion: (el) ->
    $.get '/api/localAppVersion', (localVersion) ->
      el.append " #{localVersion}"
      $.get '/api/remoteAppVersion', (remoteVersion) ->
        if isNewer(localVersion, remoteVersion)
          el.append "<br><small>(newer version available: #{remoteVersion})</small>"
