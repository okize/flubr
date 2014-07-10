$ = require 'jquery'
msg = require './messaging'

module.exports =

  # this is dumb
  _getUserRowHtml: (user) ->
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

  _showUserAdded: (user) ->
    msg.success "#{user.userName} added!"
    $('#js-add-user')[0].reset()
    $('.user-table tbody').append(@_getUserRowHtml user)

  _deleteUserInUi: ($el) ->
    username = $el.parent('td').prev().prev().text()
    msg.notice username + ' deleted!'
    $el.closest('tr').remove()

  deleteUser: ($el) ->
    verify = confirm 'Are you sure you want to delete this user?'
    if verify == true
      id = $el.attr('id')
      $.ajax
        type: 'DELETE'
        url: 'api/users/' + id
        success: =>
          @_deleteUserInUi $el
        error: ->
          msg.error 'image could not be deleted!'
        contentType: 'application/json'

  addUser: ($el) ->
    data =
      user: $el.find('#username').val()
    $.ajax
      type: 'POST'
      url: '/api/users'
      success: (response) =>
        @_showUserAdded response
      error: (error) ->
        if error.responseText
          msg.error JSON.parse(error.responseText).error
        else
          msg.error 'Unable to add user'
      contentType: 'application/json'
      data: JSON.stringify(data)