$ = require 'jquery'
msg = require './messaging'
help = require './helpers'

module.exports =

  # this is so dumb
  _getImageSetHtml: (newKind) ->
    if newKind == 'pass'
      '''
      <div class="image-setting set-pass">
        <button class="button-icon is-pass" disabled="disabled">
          <span class="icon icon-thumbs-up"></span>
        </button>
      </div>
      <div class="image-setting set-fail">
        <button class="button-icon js-change-image-kind is-fail">
          <span class="icon icon-thumbs-o-down"</span>
        </button>
      </div>
      '''
    else
      '''
      <div class="image-setting set-pass">
        <button class="button-icon js-change-image-kind is-pass">
          <span class="icon icon-thumbs-o-up"</span>
        </button>
      </div>
      <div class="image-setting set-fail">
        <button class="button-icon is-fail" disabled="disabled">
          <span class="icon icon-thumbs-down"</span>
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

  _getImageCountsByType: () ->
    passBar = $('#js-image-stats-pass')
    failBar = $('#js-image-stats-fail')
    {
      pass: parseInt(passBar.text(), 10),
      fail: parseInt(failBar.text(), 10)
    }

  _updateBars: (values) ->
    passBar = $('#js-image-stats-pass')
    failBar = $('#js-image-stats-fail')
    passWidth = (values.pass / (values.pass + values.fail)) * 100 + '%'
    failWidth = (values.fail / (values.pass + values.fail)) * 100 + '%'
    passBar.text(values.pass).css('width', passWidth)
    failBar.text(values.fail).css('width', failWidth)

  _updateImageStats: (operation, type) ->
    values = @_getImageCountsByType()
    if type == 'pass'
      if operation == 'switch'
        values.pass++
        values.fail--
      else if operation == 'delete'
        values.pass--
      @_updateBars values
    else if type == 'fail'
      if operation == 'switch'
        values.pass--
        values.fail++
      else if operation == 'delete'
        values.fail--
      @_updateBars values

  _deleteImageInUi: ($el) ->
    msg.notice 'Image deleted!'
    help.animate $el, 'delete'

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
