$ = require 'jquery'
msg = require './messaging'
imageCards = require './imageCards'

module.exports = () ->

  getUserRowHtml = (user) ->
    html = """
       <tr>
        <td>
          <img class="avatar" src="#{user.avatar}" alt="avatar image") />
        </td>
        <td>#{user.displayName}</td>
        <td>#{user.userName}</td>
        <td>#{user.created_at}</td>
        <td class="align-right">
          <span class="icon icon-trash-o button-delete js-delete-user" id="#{user.id}" title="Delete user"></span>
        </td>
       </tr>
       """
    html

  getImageSetHtml = (imageKind) ->
    if imageKind == 'pass'
      '<li><strong>pass</strong></li>' +
      '<li><a href="#" class="change-image-kind isPass">fail</a></li>' +
      '<li><a href="#" class="delete-image">delete</a></li>'
    else
      '<li><a href="#" class="change-image-kind isFail">pass</a></li>' +
      '<li><strong>fail</strong></li>' +
      '<li><a href="#" class="delete-image">delete</a></li>'

  # getThumbnail = (url) ->
  #   thumbnail = (url.substring(0, url.length - 4)) + 's.jpg'

  # displayImages = (data) ->
  #   list = $('#js-image-cards')
  #   html = ''
  #   $.each data, (i) ->
  #     html +=
  #       "<li class='image-card' id='#{data[i]._id}'>" +
  #       "<ul class='set-image-kind'>#{getImageSetHtml(data[i].kind)}</ul>" +
  #       "<a href='#{data[i].image_url}'>" +
  #       "<img src='#{getThumbnail(data[i].image_url)}' />" +
  #       "</a>" +
  #       "<div class='delete-image'><a href='#'>delete</a></div>" +
  #       "</li>"
  #   list.append(html).show()

  showImageAdded = (url) ->
    msg.notice "<a href='#{url}'>Image added!</a>"
    $('#js-add-image')[0].reset()

  showUserAdded = (user) ->
    msg.notice "#{user.userName} added!"
    $('#js-add-user')[0].reset()
    $('.user-table tbody').append(getUserRowHtml user)

  switchImageKind = (el, newKind, id) ->
    msg.notice "Changed image to #{newKind}"
    oldKind = if (newKind == 'pass') then 'fail' else 'pass'
    el.closest('.image-card')
      .removeClass('image-card-' + oldKind)
      .addClass('image-card-' + newKind)
    el.closest('.image-settings')
      .html( getImageSetHtml newKind )

  deleteUserInUi = (el) ->
    username = el.parent('td').prev().prev().text()
    msg.notice username + ' deleted!'
    el.closest('tr').remove()

  deleteImageInUi = (el) ->
    msg.notice 'Image deleted!'
    el.closest('.image-card').remove()

  $('body').on 'click', '.change-image-kind', (e) ->
    e.preventDefault()
    $this = $(this)
    id = $this.closest('.image-card').attr('id')
    data =
      kind: if $this.hasClass 'isPass' then 'fail' else 'pass'
    $.ajax
      type: 'PUT'
      url: 'api/images/' + id
      success: ->
        switchImageKind $this, data.kind
      error: ->
        msg.error 'Image kind could not be changed'
      contentType: 'application/json'
      data: JSON.stringify(data)

  $('body').on 'click', '.delete-image', (e) ->
    e.preventDefault()
    verify = confirm 'Are you sure you want to delete this image?'
    if verify == true
      $this = $(this)
      id = $this.closest('.image-card').attr('id')
      $.ajax
        type: 'DELETE'
        url: 'api/images/' + id
        success: ->
          deleteImageInUi $this
        error: ->
          msg.error 'image could not be deleted!'
        contentType: 'application/json'

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

  # $('body').on 'click', '.pass-fail-toggle label', (e) ->
  #   $(this).prev().prop('checked', 'checked')

  $('#js-add-user').on 'submit', (e) ->
    e.preventDefault()
    $this = $(this)
    data =
      user: $this.find('#username').val()
    $.ajax
      type: 'POST'
      url: '/api/users'
      success: (response) ->
        showUserAdded response
      error: (error) ->
        if error.responseText
          msg.error JSON.parse(error.responseText).error
        else
          msg.error 'Unable to add user'
      contentType: 'application/json'
      data: JSON.stringify(data)

  $('body').on 'click', '.js-delete-user', (e) ->
    e.preventDefault()
    verify = confirm 'Are you sure you want to delete this user?'
    if verify == true
      $this = $(this)
      id = $this.attr('id')
      $.ajax
        type: 'DELETE'
        url: 'api/users/' + id
        success: ->
          deleteUserInUi $this
        error: ->
          msg.error 'image could not be deleted!'
        contentType: 'application/json'
