$ = require 'jquery'
Pjax = require 'pjax'
msg = require './messaging'
imageCard = require './imageCards'
user = require './users'
image = require './images'

module.exports = () ->

  $body = $('body')

  $body.on 'click', '.js-change-image-kind', (e) ->
    e.preventDefault()
    imageCard.switchImageKind $(this)

  $body.on 'click', '.js-delete-image', (e) ->
    e.preventDefault()
    imageCard.deleteImage $(this)

  $body.on 'click', '.js-delete-user', (e) ->
    e.preventDefault()
    user.deleteUser $(this)

  $('#js-add-user').on 'submit', (e) ->
    e.preventDefault()
    user.addUser $(this)

  $('#js-add-image').on 'submit', (e) ->
    e.preventDefault()
    image.addImage $(this)

  new Pjax(
    selectors: [
      'title'
    ]
    elements: '.js-pjax'
    debug: window.location.hostname == 'localhost'
  )

  document.addEventListener 'pjax:send', ->
    console.log 'pjax:send'

  document.addEventListener 'pjax:success', ->
    console.log 'pjax:success'
