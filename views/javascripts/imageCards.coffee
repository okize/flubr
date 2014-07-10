$ = require 'jquery'
msg = require './messaging'

module.exports =

  # this is so dumb
  _getImageSetHtml: (newKind) ->
    if newKind == 'pass'
      '<li><div class="is-pass"><span class="icon icon-thumbs-up"</span></div></li>' +
      '<li><a href="#" class="js-change-image-kind is-fail"><span class="icon icon-thumbs-o-down"</span></a></li>' +
      '<li><a href="#" class="js-delete-image"><span class="icon icon-trash-o"></span></a></li>'
    else
      '<li><a href="#" class="js-change-image-kind is-pass"><span class="icon icon-thumbs-o-up"</span></a></li>' +
      '<li><div class="is-fail"><span class="icon icon-thumbs-down"</span></div></li>' +
      '<li><a href="#" class="js-delete-image"><span class="icon icon-trash-o"></span></a></li>'

  _updateImageInUi: (card, newKind, oldKind) ->
    msg.notice "Changed image to #{newKind}"
    card
      .removeClass('image-card-' + oldKind)
      .addClass('image-card-' + newKind)
    card
      .find('.image-settings')
      .html('updated!')
      .html( @_getImageSetHtml newKind )

  _deleteImageInUi: ($el) ->
    msg.notice 'Image deleted!'
    $el.remove()

  switchImageKind: ($el) ->
    card = $el.closest('.image-card')
    id = card.attr('id')
    oldKind = if card.hasClass 'image-card-pass' then 'pass' else 'fail'
    newKind = if oldKind == 'pass' then 'fail' else 'pass'
    data =
      kind: newKind
    $.ajax
      type: 'PUT'
      url: 'api/images/' + id
      success: =>
        @_updateImageInUi card, newKind, oldKind
      error: ->
        msg.error 'Image kind could not be changed'
      contentType: 'application/json'
      data: JSON.stringify(data)

  deleteImage: ($el) ->
    verify = confirm 'Are you sure you want to delete this image?'
    if verify == true
      card = $el.closest('.image-card')
      id = card.attr('id')
      $.ajax
        type: 'DELETE'
        url: 'api/images/' + id
        success: =>
          @_deleteImageInUi card
        error: ->
          msg.error 'image could not be deleted!'
        contentType: 'application/json'
