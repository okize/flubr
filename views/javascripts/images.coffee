$ = require 'jquery'
msg = require './messaging'

module.exports =

  _showImageAdded: (url) ->
    msg.success "<a href='#{url}'>Image added!</a>"
    $('#js-add-image')[0].reset()

  addImage: ($el) ->
    data =
      source_url: $el.find('#image-url').val()
      kind: $el.find('input[name=kind]:checked').val()
    $.ajax
      type: 'POST'
      url: '/api/images'
      success: =>
        @_showImageAdded data.source_url
      error: (error) ->
        if error.responseText
          msg.error JSON.parse(error.responseText).error
        else
          msg.error 'Sorry, image could not be added!'
      complete: ->
        ($el).removeClass('disabled').find(':input').prop('disabled', false)
      contentType: 'application/json'
      data: JSON.stringify(data)
