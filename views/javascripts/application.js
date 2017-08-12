import $ from 'jquery';
import msg from './messaging';
import imageCard from './imageCards';
import user from './users';
import image from './images';
import stats from './stats';

const application = () => {
  let timer;

  const $body = $('body');

  const versionEl = $('#app-version');
  if (versionEl.length) { stats.getVersion(versionEl); }

  $body.on('click', '.js-change-image-kind', function (e) {
    e.stopPropagation();
    e.preventDefault();
    return imageCard.switchImageKind($(this));
  });

  $body.on('click', '.js-flip-card', function (e) {
    e.preventDefault();
    return imageCard.flipCard($(this));
  });

  $body.on('mouseenter', '.js-image-card', function (e) {
    return timer = setTimeout(() => imageCard.loadAnimation($(this))
      , 500);
  });

  $body.on('mouseleave', '.js-image-card', e => clearTimeout(timer));

  $body.on('click', '.js-delete-image', function (e) {
    e.preventDefault();
    return imageCard.deleteImage($(this));
  });

  $body.on('click', '.js-delete-user', function (e) {
    e.preventDefault();
    return user.deleteUser($(this));
  });

  $('#js-add-user').on('submit', function (e) {
    e.preventDefault();
    return user.addUser($(this));
  });

  return $('#js-add-image').on('submit', function (e) {
    e.preventDefault();
    $(this).addClass('disabled').find(':input').prop('disabled', true);
    return image.addImage($(this));
  });
}

export default application;
