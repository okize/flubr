$ = require 'jquery'
msg = require './messaging'
imageCard = require './imageCards'

module.exports = () ->

  $('body').on 'click', '.change-image-kind', (e) ->
    e.preventDefault()
    imageCard.switchImageKind $(this)

  $('body').on 'click', '.delete-image', (e) ->
    e.preventDefault()
    imageCard.deleteImage $(this)

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

  showImageAdded = (url) ->
    msg.success "<a href='#{url}'>Image added!</a>"
    $('#js-add-image')[0].reset()

  showUserAdded = (user) ->
    msg.success "#{user.userName} added!"
    $('#js-add-user')[0].reset()
    $('.user-table tbody').append(getUserRowHtml user)

  deleteUserInUi = (el) ->
    username = el.parent('td').prev().prev().text()
    msg.notice username + ' deleted!'
    el.closest('tr').remove()

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


