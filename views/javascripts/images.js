import $ from 'jquery';
import msg from './messaging';
import lazy from './lazy';

lazy('image-thumbnail');

export default {
  _showImageAdded(url) {
    msg.success(`<a href='${url}'>Image added!</a>`);
    return $('#js-add-image')[0].reset();
  },

  addImage($el) {
    const data = {
      source_url: $el.find('#image-url').val(),
      kind: $el.find('input[name=kind]:checked').val(),
    };

    return $.ajax({
      type: 'POST',
      url: '/api/images',
      contentType: 'application/json',
      data: JSON.stringify(data),
      success: (data) => this._showImageAdded(data.image_url),
      error(error) {
        if (error.responseText) {
          return msg.error(JSON.parse(error.responseText).error);
        }
        return msg.error('Sorry, image could not be added!');
      },
      complete() {
        return ($el).removeClass('disabled').find(':input').prop('disabled', false);
      },
    });
  },
};
