import $ from 'jquery';
import key from 'keymaster';
import cards from './imageCards';

export default function() {

  key('p', function() {
    if ($('#image-kind-pass').length) {
      return $('#image-kind-pass').click();
    }
  });

  key('f', function() {
    if ($('#image-kind-fail').length) {
      return $('#image-kind-fail').click();
    }
  });

  key('shift+f', function() {
    if ($('.image-cards').length) {
      return cards.flipAllCards();
    }
  });

  return key('space', function() {
    if ($('#image-url')) {
      return $('#image-url').focus();
    }
  });
};
