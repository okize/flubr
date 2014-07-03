$ = require 'jquery'

module.exports = () ->

  showMessage = (msg, type) ->
    $('#messaging').prepend("<li class='flash-#{type}'>#{msg}</li>")

  getImageSetHtml = (imageKind) ->
    if imageKind == 'pass'
      '<li><strong>pass</strong></li>' +
      '<li><a href="#" class="change-image-kind isPass">fail</a></li>' +
      '<li><a href="#" class="delete-image">delete</a></li>'
    else
      '<li><a href="#" class="change-image-kind isFail">pass</a></li>' +
      '<li><strong>fail</strong></li>' +
      '<li><a href="#" class="delete-image">delete</a></li>'

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
          <button class="button-delete js-delete-user" id="#{user.id}">
            Delete user
          </button>
        </td>
       </tr>
       """
    html

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
    showMessage "<a href='#{url}'>Image added!</a>", 'notice'
    $('#js-add-image')[0].reset()

  showUserAdded = (user) ->
    showMessage "#{user.userName} added!", 'notice'
    $('#js-add-user')[0].reset()
    $('.user-table tbody').append(getUserRowHtml user)

  switchImageKind = (el, newKind, id) ->
    showMessage "Changed image to #{newKind}", 'notice'
    oldKind = if (newKind == 'pass') then 'fail' else 'pass'
    el.closest('.image-card')
      .removeClass('image-card-' + oldKind)
      .addClass('image-card-' + newKind)
    el.closest('.image-settings')
      .html( getImageSetHtml newKind )

  deleteUserInUi = (el) ->
    username = el.parent('td').prev().prev().text()
    showMessage username + ' deleted!', 'notice'
    el.closest('tr').remove()

  deleteImageInUi = (el) ->
    showMessage 'Image deleted!', 'notice'
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
        showMessage 'Image kind could not be changed', 'error'
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
          showMessage 'image could not be deleted!', 'error'
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
        showMessage 'image could not be added!', 'error'
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
      error: ->
        showMessage 'user could not be added!', 'error'
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
          showMessage 'image could not be deleted!', 'error'
        contentType: 'application/json'
