$ = require 'jquery'

notice = (msg, type) ->
  $('#messaging').prepend("<li class='flash-#{type}'>#{msg}</li>")

module.exports = notice