var deleteImageInUi, displayImages, getImageSetHtml, getThumbnail, imageForm, showImageAdded, switchImageKind;

getImageSetHtml = function(imageKind) {
  if (imageKind === 'pass') {
    return "<li>pass</li><li><a href='#' class='changeImageKind isPass'>fail</a></li>";
  } else {
    return "<li><a href='#' class='changeImageKind isFail'>pass</a></li><li>fail</li>";
  }
};

getThumbnail = function(url) {
  var thumbnail;
  return thumbnail = (url.substring(0, url.length - 4)) + 's.jpg';
};

displayImages = function(data) {
  var html, list;
  list = $('#js-image-list');
  html = '';
  $.each(data, function(i) {
    return html += ("<li class='image-item' id='" + data[i]._id + "'>") + ("<ul class='set-image-kind'>" + (getImageSetHtml(data[i].kind)) + "</ul>") + ("<a href='" + data[i].image_url + "'><img src='" + (getThumbnail(data[i].image_url)) + "' class='pf-image' /></a>") + "<div class='delete-image'><a href='#'>delete</a></div>" + "</li>";
  });
  return list.append(html).show();
};

showImageAdded = function() {
  return $('#messaging').html('Image added!');
};

switchImageKind = function(el, newKind) {
  el.closest('.set-image-kind').html(getImageSetHtml(newKind));
  return $('#messaging').html('Image kind changed!');
};

deleteImageInUi = function(el) {
  el.closest('.image-item').remove();
  return $('#messaging').html('Image deleted!');
};

$('body').on('click', '.changeImageKind', function(e) {
  var $this, data, id;
  e.preventDefault();
  $this = $(this);
  id = $this.closest('.image-item').attr('id');
  data = {
    kind: $this.hasClass('isPass') ? 'fail' : 'pass'
  };
  return $.ajax({
    type: 'PUT',
    url: 'api/images/' + id,
    success: switchImageKind($this, data.kind),
    contentType: 'application/json',
    data: JSON.stringify(data)
  });
});

$('body').on('click', '.delete-image a', function(e) {
  var $this, id, verify;
  e.preventDefault();
  verify = confirm('Are you sure you want to delete this image?');
  if (verify === true) {
    $this = $(this);
    id = $this.closest('.image-item').attr('id');
    return $.ajax({
      type: 'DELETE',
      url: 'api/images/' + id,
      success: deleteImageInUi($this),
      contentType: 'application/json'
    });
  }
});

imageForm = $('#js-add-image');

imageForm.on('submit', function(e) {
  var data;
  e.preventDefault();
  data = {
    image_url: imageForm.find('#imageUrl').val(),
    kind: imageForm.find('input[name=kind]:checked').val()
  };
  return $.ajax({
    type: 'POST',
    url: 'api/images',
    success: showImageAdded,
    contentType: 'application/json',
    data: JSON.stringify(data)
  });
});

$('#js-show-images').on('click', function() {
  $(this).remove();
  return $.ajax({
    type: 'GET',
    url: 'api/images',
    success: displayImages,
    dataType: 'json'
  });
});
