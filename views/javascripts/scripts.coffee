$('#js-add-image').on 'submit', (e) ->
  e.preventDefault()
  console.log 'form submitted'

displayImages = (data) ->
  list = $('#js-image-list')
  html = ''
  $.each data, (i) ->
    html += "<li><img src='#{data[i].image_url}' /></li>"
  list.append(html).show()

$('#js-show-images').on 'click', ->
  $(this).remove()
  # show images
  $.ajax
    url: 'api/images'
    success: displayImages
    dataType: 'json'
