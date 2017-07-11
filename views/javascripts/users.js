import $ from 'jquery';
import msg from './messaging';
import help from './helpers';

export default {

  // this is dumb
  _getUserRowHtml(user) {
    const createDate = help.formatTime(user.created_at);
    const html = `\
<tr>
 <td>
   <img class="avatar" src="${user.avatar}" alt="avatar image") />
 </td>
 <td>${user.displayName}</td>
 <td>${user.userName}</td>
 <td>${createDate}</td>
 <td class="align-right">
   <span class="icon icon-trash-o button-delete js-delete-user"
   id="${user.userid}" title="Delete user"></span>
 </td>
</tr>\
`;
    return html;
  },

  _showUserAdded(user) {
    msg.success(`${user.userName} added!`);
    $('#js-add-user')[0].reset();
    const $row = $(this._getUserRowHtml(user));
    $('.user-table tbody').append($row);
    return help.animate($row, 'addRow');
  },

  _deleteUserInUi($el, username) {
    msg.notice(username + ' deleted!');
    const $row = $el.closest('tr');
    return help.animate($row, 'deleteRow', () => $row.remove());
  },

  deleteUser($el) {
    const verify = confirm('Are you sure you want to delete this user?');
    if (verify === true) {
      const id = $el.attr('id');
      return $.ajax({
        type: 'DELETE',
        url: `api/users/${id}`,
        success: response => {
          return this._deleteUserInUi($el, response.userName);
        },
        error(error) {
          if (error.responseText) {
            return msg.error(JSON.parse(error.responseText).error);
          } else {
            return msg.error('Sorry, user could not be deleted');
          }
        },
        contentType: 'application/json'
      });
    }
  },

  addUser($el) {
    const data =
      {user: $el.find('#username').val()};
    return $.ajax({
      type: 'POST',
      url: '/api/users',
      success: response => {
        return this._showUserAdded(response);
      },
      error(error) {
        if (error.responseText) {
          return msg.error(JSON.parse(error.responseText).error);
        } else {
          return msg.error('Sorry, user could not be added');
        }
      },
      contentType: 'application/json',
      data: JSON.stringify(data)
    });
  }
};