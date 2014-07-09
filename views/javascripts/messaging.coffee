$ = require 'jquery'

module.exports =

  # add message to the dom
  _send: (type, msg) ->
    html = "<li class='flash-#{type}'>#{msg}</li>"
    $('#messaging').prepend(html)

  notice: (msg) ->
    @_send 'notice', msg

  error: (msg) ->
    @_send 'error', msg

  warning: (msg) ->
    @_send 'warning', msg

  success: (msg) ->
    @_send 'success', msg
