$ = require 'jquery'
msg = require './messaging'
imageCard = require './imageCards'
user = require './users'
image = require './images'
stats = require './stats'

module.exports = () ->

  $body = $('body')

  versionEl = $('#app-version')
  stats.getVersion(versionEl) if versionEl.length

  $body.on 'click', '.js-change-image-kind', (e) ->
    e.stopPropagation()
    e.preventDefault()
    imageCard.switchImageKind $(this)

  $body.on 'click', '.js-flip-card', (e) ->
    e.preventDefault()
    imageCard.flipCard $(this)

  $body.on 'mouseenter', '.js-image-card', (e) ->
    imageCard.loadAnimation $(this)

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
    $(this).addClass('disabled').find(':input').prop('disabled', true)
    image.addImage $(this)
