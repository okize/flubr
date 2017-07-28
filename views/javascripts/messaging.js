import $ from 'jquery';
import help from './helpers';

export default {

  // add message to the dom
  _send(type, msg) {
    let icon;
    switch (type) {
      case 'notice': icon = 'info-circle'; break;
      case 'error': icon = 'times-circle'; break;
      case 'warning': icon = 'exclamation-circle'; break;
      case 'success': icon = 'check-circle'; break;
    }
    const $html =
      $('<li />')
        .addClass(`flash-${type} flag`)
        .append(`<span class='icon icon-${icon} flag-image'></span>`)
        .append(`<span class='flag-body'>${msg}</span>`);
    $('#messaging').prepend($html);
    return help.animate($html, 'pop');
  },

  notice(msg) {
    return this._send('notice', msg);
  },

  error(msg) {
    return this._send('error', msg);
  },

  warning(msg) {
    return this._send('warning', msg);
  },

  success(msg) {
    return this._send('success', msg);
  },
};
