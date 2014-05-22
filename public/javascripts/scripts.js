var displayImages;

$('#js-add-image').on('submit', function(e) {
  e.preventDefault();
  return console.log('form submitted');
});

displayImages = function(data) {
  var html, list;
  list = $('#js-image-list');
  html = '';
  $.each(data, function(i) {
    return html += "<li><img src='" + data[i].image_url + "' /></li>";
  });
  return list.append(html).show();
};

$('#js-show-images').on('click', function() {
  $(this).remove();
  return $.ajax({
    url: 'api/images',
    success: displayImages,
    dataType: 'json'
  });
});
