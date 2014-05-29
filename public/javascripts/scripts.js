var displayImages, imageForm, showImageAdded;

displayImages = function(data) {
  var html, list;
  list = $('#js-image-list');
  html = '';
  $.each(data, function(i) {
    return html += "<li><img src='" + data[i].image_url + "' class='pf-image' /></li>";
  });
  return list.append(html).show();
};

showImageAdded = function() {
  return $('#messaging').html('Image added!');
};

imageForm = $('#js-add-image');

imageForm.on('submit', function(e) {
  var data;
  e.preventDefault();
  data = {
    image_url: imageForm.find('#imageUrl').val(),
    kind: imageForm.find('input[name=kind]:checked').val()
  };
  return $.ajax({
    type: 'post',
    url: 'api/images',
    success: showImageAdded,
    contentType: 'application/json',
    data: JSON.stringify(data)
  });
});

$('#js-show-images').on('click', function() {
  $(this).remove();
  return $.ajax({
    url: 'api/images',
    success: displayImages,
    dataType: 'json'
  });
});
