$ = require 'jquery'
msg = require './messaging'
help = require './helpers'

module.exports =

  # this is dumb
  _getUserRowHtml: (user) ->
    createDate = help.formatTime(user.created_at)
    html = """
       <tr>
        <td>
          <img class="avatar" src="#{user.avatar}" alt="avatar image") />
        </td>
        <td>#{user.displayName}</td>
        <td>#{user.userName}</td>
        <td>#{createDate}</td>
        <td class="align-right">
          <span class="icon icon-trash-o button-delete js-delete-user"
          id="#{user.userid}" title="Delete user"></span>
        </td>
       </tr>
       """
    html

  _showUserAdded: (user) ->
    msg.success "#{user.userName} added!"
    $('#js-add-user')[0].reset()
    $row = $(@_getUserRowHtml user)
    $('.user-table tbody').append($row)
    help.animate $row, 'addRow'

  _deleteUserInUi: ($el, username) ->
    msg.notice username + ' deleted!'
    $row = $el.closest('tr')
    help.animate $row, 'deleteRow', ->
      $row.remove()

  deleteUser: ($el) ->
    verify = confirm 'Are you sure you want to delete this user?'
    if verify == true
      id = $el.attr('id')
      $.ajax
        type: 'DELETE'
        url: 'api/users/' + id
        success: (response) =>
          @_deleteUserInUi $el, response.userName
        error: (error) ->
          if error.responseText
            msg.error JSON.parse(error.responseText).error
          else
            msg.error 'Sorry, user could not be deleted'
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
          msg.error 'Sorry, user could not be deleted'
      contentType: 'application/json'
      data: JSON.stringify(data)