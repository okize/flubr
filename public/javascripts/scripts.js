var deleteImage, displayImages, imageForm, showImageAdded, switchImageKind;

displayImages = function(data) {
  var html, list, setImage;
  list = $('#js-image-list');
  html = '';
  setImage = '';
  $.each(data, function(i) {
    if (data[i].kind === 'pass') {
      setImage = "<li>pass</li><li><a href='#' class='changeImageKind isPass'>fail</a></li>";
    } else {
      setImage = "<li><a href='#' class='changeImageKind isFail'>pass</a></li><li>fail</li>";
    }
    return html += ("<li class='image-item' id='" + data[i]._id + "'>") + ("<ul class='set-image-kind'>" + setImage + "</ul>") + ("<img src='" + data[i].image_url + "' class='pf-image' />") + "<div class='delete-image'><a href='#'>delete</a></div>" + "</li>";
  });
  return list.append(html).show();
};

showImageAdded = function() {
  return $('#messaging').html('Image added!');
};

switchImageKind = function(el) {
  console.log(el);
  return $('#messaging').html('Image changed!');
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
    success: switchImageKind($this),
    contentType: 'application/json',
    data: JSON.stringify(data)
  });
});

deleteImage = function(el) {
  el.closest('.image-item').remove();
  return $('#messaging').html('Image deleted!');
};

$('body').on('click', '.delete-image a', function(e) {
  var $this, id;
  e.preventDefault();
  $this = $(this);
  id = $this.closest('.image-item').attr('id');
  return $.ajax({
    type: 'DELETE',
    url: 'api/images/' + id,
    success: deleteImage($this),
    contentType: 'application/json'
  });
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
