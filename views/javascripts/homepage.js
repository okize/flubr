import $ from 'jquery';

export default function() {

  // homepage random images
  const getRandomImage = (el, type) =>
    $.get(`/api/images/random/${type}`, data => el.append(`<img src='${data}' />`))
  ;

  const randomPassImage = $('#random-pass-image');
  const randomFailImage = $('#random-fail-image');

  if (randomPassImage.length && randomFailImage.length) {
    getRandomImage(randomPassImage, 'pass');
    return getRandomImage(randomFailImage, 'fail');
  }
};
