import $ from 'jquery';
import key from 'keymaster';
import cards from './imageCards';

const keyboard = () => {
  key('p', () => {
    if ($('#image-kind-pass').length) {
      return $('#image-kind-pass').click();
    }
  });

  key('f', () => {
    if ($('#image-kind-fail').length) {
      return $('#image-kind-fail').click();
    }
  });

  key('shift+f', () => {
    if ($('.image-cards').length) {
      return cards.flipAllCards();
    }
  });

  return key('space', () => {
    if ($('#image-url')) {
      return $('#image-url').focus();
    }
  });
};

export default keyboard;
