$ = require 'jquery'
key = require 'keymaster'

module.exports = () ->

  key 'p', ->
    $('#image-kind-pass').click()

  key 'f', ->
    $('#image-kind-fail').click()

  key 'space', ->
    $('#image-url').focus()
