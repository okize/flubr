# jquery has to be assigned to window for velocity to work (as of 0.5.1)
$ = window.jQuery = window.$ = require 'jquery'
velocity = require 'velocity-animate'
velocityui = require 'velocity-animate/velocity.ui'

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
    $html
      .velocity('callout.pulse', 350)

  notice: (msg) ->
    @_send 'notice', msg

  error: (msg) ->
    @_send 'error', msg

  warning: (msg) ->
    @_send 'warning', msg

  success: (msg) ->
    @_send 'success', msg
