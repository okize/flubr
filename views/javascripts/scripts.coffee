displayImages = (data) ->
  list = $('#image-list')
  html = ''
  $.each data, (i) ->
    html += "<li><img src='#{data[i].image_url}' /></li>"
  list.append(html)

$.ajax
  url: 'api/images'
  success: displayImages
  dataType: 'json'
