displayImages = (data) ->
  list = $('#js-image-list')
  html = ''
  $.each data, (i) ->
    html += "<li><img src='#{data[i].image_url}' /></li>"
  list.append(html).show()

showImageAdded = ->
  $('#messaging').html('Image added!')

imageForm = $('#js-add-image')

imageForm.on 'submit', (e) ->
  e.preventDefault()
  data =
    image_url: imageForm.find('#imageUrl').val()
    kind: imageForm.find('input[name=kind]:checked').val()
  $.ajax
    type: 'post'
    url: 'api/images'
    success: showImageAdded
    contentType: 'application/json',
    data: JSON.stringify(data)

$('#js-show-images').on 'click', ->
  $(this).remove()
  # show images
  $.ajax
    url: 'api/images'
    success: displayImages
    dataType: 'json'
