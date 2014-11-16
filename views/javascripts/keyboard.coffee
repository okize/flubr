$ = require 'jquery'
key = require 'keymaster'
cards = require './imageCards'

module.exports = () ->

  key 'p', ->
    if $('#image-kind-pass').length
      $('#image-kind-pass').click()

  key 'f', ->
    if $('#image-kind-fail').length
      $('#image-kind-fail').click()
    if $('.image-cards').length
      cards.flipAllCards()

  key 'space', ->
    if $('#image-url')
      $('#image-url').focus()
