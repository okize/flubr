$ = require 'jquery'
msg = require './messaging'
imageCard = require './imageCards'
user = require './users'

module.exports = () ->

  $body = $('body')

  $body.on 'click', '.change-image-kind', (e) ->
    e.preventDefault()
    imageCard.switchImageKind $(this)

  $body.on 'click', '.delete-image', (e) ->
    e.preventDefault()
    imageCard.deleteImage $(this)

  $body.on 'click', '.js-delete-user', (e) ->
    e.preventDefault()
    user.deleteUser $(this)

  $('#js-add-user').on 'submit', (e) ->
    e.preventDefault()
    user.addUser $(this)

  showImageAdded = (url) ->
    msg.success "<a href='#{url}'>Image added!</a>"
    $('#js-add-image')[0].reset()

  $('#js-add-image').on 'submit', (e) ->
    e.preventDefault()
    $this = $(this)
    data =
      source_url: $this.find('#imageUrl').val()
      kind: $this.find('input[name=kind]:checked').val()
    $.ajax
      type: 'POST'
      url: '/api/images'
      success: ->
        showImageAdded data.source_url
      error: ->
        msg.error 'image could not be added!'
      contentType: 'application/json'
      data: JSON.stringify(data)




