$ = require 'jquery'
help = require './helpers'

module.exports =

  # add message to the dom
  _send: (type, msg) ->
    switch type
      when 'notice' then icon = 'info-circle'
      when 'error' then icon = 'times-circle'
      when 'warning' then icon = 'exclamation-circle'
      when 'success' then icon = 'check-circle'
    $html =
      $('<li />')
        .addClass("flash-#{type} flag")
        .append("<span class='icon icon-#{icon} flag-image'></span>")
        .append("<span class='flag-body'>#{msg}</span>")
    $('#messaging').prepend($html)
    help.animate $html, 'pop'

  notice: (msg) ->
    @_send 'notice', msg

  error: (msg) ->
    @_send 'error', msg

  warning: (msg) ->
    @_send 'warning', msg

  success: (msg) ->
    @_send 'success', msg
