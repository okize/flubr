$ = require 'jquery'

module.exports =

  # add message to the dom
  _send: (type, msg) ->
    switch type
      when 'notice' then icon = 'info-circle'
      when 'error' then icon = 'times-circle'
      when 'warning' then icon = 'exclamation-circle'
      when 'success' then icon = 'check-circle'
    html = "<li class='flash-#{type}'><span class='icon icon-#{icon}'></span>#{msg}</li>"
    $('#messaging').prepend(html)

  notice: (msg) ->
    @_send 'notice', msg

  error: (msg) ->
    @_send 'error', msg

  warning: (msg) ->
    @_send 'warning', msg

  success: (msg) ->
    @_send 'success', msg
