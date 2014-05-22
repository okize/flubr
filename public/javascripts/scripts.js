var displayImages;

displayImages = function(data) {
  var html, list;
  list = $('#image-list');
  html = '';
  $.each(data, function(i) {
    return html += "<li><img src='" + data[i].image_url + "' /></li>";
  });
  return list.append(html);
};

$.ajax({
  url: 'api/images',
  success: displayImages,
  dataType: 'json'
});
