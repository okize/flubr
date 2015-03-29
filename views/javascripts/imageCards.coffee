$ = require 'jquery'
msg = require './messaging'
help = require './helpers'

module.exports =

  # TODO fix this awful code
  _getImageSetHtml: (newKind) ->
    if newKind == 'pass'
      '''
      <div class="image-setting set-pass">
        <button class="button-icon is-pass" disabled="disabled">
          <span class="icon icon-like2"></span>
        </button>
      </div>
      <div class="image-setting set-fail js-change-image-kind">
        <button class="button-icon is-fail">
          <span class="icon icon-like2 icon-rotate-180"</span>
        </button>
      </div>
      '''
    else
      '''
      <div class="image-setting set-pass js-change-image-kind">
        <button class="button-icon is-pass">
          <span class="icon icon-like2"</span>
        </button>
      </div>
      <div class="image-setting set-fail">
        <button class="button-icon is-fail" disabled="disabled">
          <span class="icon icon-like2 icon-rotate-180"</span>
        </button>
      </div>
      '''

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
    help.animate $el, 'delete'

  flipCard: ($el) ->
    if $el.hasClass('image-card-front')
      $el.hide()
      $el.closest('.image-card').find('.image-card-back').show()
    else
      card = $el.closest('.image-card')
      card.find('.image-card-back').hide()
      card.find('.image-card-front').show()

  flipAllCards: ->
    firstCard = $('.js-flip-card').not('button').first().css('display')
    if firstCard == 'none'
      $('.image-card-front').show()
      $('.image-card-back').hide()
    else
      $('.image-card-front').hide()
      $('.image-card-back').show()

  loadAnimation: ($el) ->
    img = $el.find('img')
    src = img.attr('src')
    original = img.data('original')
    unless (src == original)
      $.ajax
        type: 'get'
        url: original
        success: ->
          img.attr('src', original)
        error: (error) ->
          if error.responseText
            msg.error JSON.parse(error.responseText).error
          else
            msg.error 'Sorry, image kind could not be changed!'

  switchImageKind: ($el) ->
    card = $el.closest('.image-card')
    id = card.attr('id')
    oldKind = if card.hasClass 'image-card-pass' then 'pass' else 'fail'
    newKind = if oldKind == 'pass' then 'fail' else 'pass'
    data =
      kind: newKind
    $.ajax
      type: 'PUT'
      url: '/api/images/' + id
      success: =>
        @_updateImageInUi card, newKind, oldKind
        @_updateImageStats 'switch', newKind
      error: (error) ->
        if error.responseText
          msg.error JSON.parse(error.responseText).error
        else
          msg.error 'Sorry, image kind could not be changed!'
      contentType: 'application/json'
      data: JSON.stringify(data)

  deleteImage: ($el) ->
    verify = confirm 'Are you sure you want to delete this image?'
    if verify == true
      card = $el.closest('.image-card')
      id = card.attr('id')
      kind = if card.hasClass 'image-card-pass' then 'pass' else 'fail'
      $.ajax
        type: 'DELETE'
        url: '/api/images/' + id
        success: =>
          @_deleteImageInUi card
          @_updateImageStats 'delete', kind
        error: (error) ->
          if error.responseText
            msg.error JSON.parse(error.responseText).error
          else
            msg.error 'Sorry, image could not be deleted!'
        contentType: 'application/json'
