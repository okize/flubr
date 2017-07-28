import $ from 'jquery';
import msg from './messaging';
import help from './helpers';

// extend jQuery XHR with progress method
(function ($) {
  const originalXhr = $.ajaxSettings.xhr;
  return $.ajaxSetup({
    progress() { return $.noop(); },
    xhr() {
      const req = originalXhr();
      const that = this;
      if (req) {
        if (typeof req.addEventListener === 'function') {
          req.addEventListener('progress', (e => that.progress(e)), false);
        }
      }
      return req;
    } });
}(jQuery));

export default {

  // TODO fix this awful code
  _getImageSetHtml(newKind) {
    if (newKind === 'pass') {
      return `\
<div class="image-setting set-pass">
  <button class="button-icon is-pass" disabled="disabled">
    <span class="icon icon-like2"></span>
  </button>
</div>
<div class="image-setting set-fail js-change-image-kind">
  <button class="button-icon is-fail">
    <span class="icon icon-like2 icon-rotate-180"</span>
  </button>
</div>\
`;
    }
    return `\
<div class="image-setting set-pass js-change-image-kind">
  <button class="button-icon is-pass">
    <span class="icon icon-like2"</span>
  </button>
</div>
<div class="image-setting set-fail">
  <button class="button-icon is-fail" disabled="disabled">
    <span class="icon icon-like2 icon-rotate-180"</span>
  </button>
</div>\
`;
  },

  _updateImageInUi(card, newKind, oldKind) {
    msg.notice(`Changed image to ${newKind}`);
    card
      .removeClass(`image-card-${oldKind}`)
      .addClass(`image-card-${newKind}`);
    return card
      .find('.image-settings')
      .html('updated!')
      .html(this._getImageSetHtml(newKind));
  },

  _deleteImageInUi($el) {
    msg.notice('Image deleted!');
    return help.animate($el, 'delete');
  },

  flipCard($el) {
    if ($el.hasClass('image-card-front')) {
      $el.hide();
      return $el.closest('.image-card').find('.image-card-back').show();
    }
    const card = $el.closest('.image-card');
    card.find('.image-card-back').hide();
    return card.find('.image-card-front').show();
  },

  flipAllCards() {
    const firstCard = $('.js-flip-card').not('button').first().css('display');
    if (firstCard === 'none') {
      $('.image-card-front').show();
      return $('.image-card-back').hide();
    }
    $('.image-card-front').hide();
    return $('.image-card-back').show();
  },

  loadAnimation($el) {
    const $img = $el.find('img');
    const src = $img.attr('src');
    const original = $img.data('original');
    if ((src !== original) && !$el.hasClass('loading')) {
      $el.addClass('loading');
      const $progress = $('<progress value="0" max="100" />');
      return $.ajax({
        type: 'get',
        url: original,
        progress(e) {
          if (e.lengthComputable) {
            $el.find('.js-flip-card').prepend($progress);
            const complete = parseInt(((e.loaded / e.total) * 100), 10);
            return $progress.val(complete);
          }
        },
        success() {
          $el.find('progress').remove();
          $el.removeClass('loading');
          $img.attr('src', original);
          return $img.attr('class', 'image-original');
        },
        error(error) {
          $el.find('progress').remove();
          $el.removeClass('loading');
          if (error.responseText) {
            return msg.error(JSON.parse(error.responseText).error);
          }
          return msg.error('Sorry, image kind could not be changed!');
        },
      });
    }
  },

  switchImageKind($el) {
    const card = $el.closest('.image-card');
    const id = card.attr('id');
    const oldKind = card.hasClass('image-card-pass') ? 'pass' : 'fail';
    const newKind = oldKind === 'pass' ? 'fail' : 'pass';
    const data =
      { kind: newKind };
    return $.ajax({
      type: 'PUT',
      url: `/api/images/${id}`,
      success: () => {
        this._updateImageInUi(card, newKind, oldKind);
        return this._updateImageStats('switch', newKind);
      },
      error(error) {
        if (error.responseText) {
          return msg.error(JSON.parse(error.responseText).error);
        }
        return msg.error('Sorry, image kind could not be changed!');
      },
      contentType: 'application/json',
      data: JSON.stringify(data),
    });
  },

  deleteImage($el) {
    const verify = confirm('Are you sure you want to delete this image?');
    if (verify === true) {
      const card = $el.closest('.image-card');
      const id = card.attr('id');
      const kind = card.hasClass('image-card-pass') ? 'pass' : 'fail';
      return $.ajax({
        type: 'DELETE',
        url: `/api/images/${id}`,
        success: () => {
          this._deleteImageInUi(card);
          return this._updateImageStats('delete', kind);
        },
        error(error) {
          if (error.responseText) {
            return msg.error(JSON.parse(error.responseText).error);
          }
          return msg.error('Sorry, image could not be deleted!');
        },
        contentType: 'application/json',
      });
    }
  },
};
