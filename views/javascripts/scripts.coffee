displayImages = (data) ->
  list = $('#js-image-list')
  html = ''
  setImage = ''
  $.each data, (i) ->
    if data[i].kind == 'pass'
      setImage = "<li>pass</li><li><a href='#' class='changeImageKind isPass'>fail</a></li>"
    else
      setImage = "<li><a href='#' class='changeImageKind isFail'>pass</a></li><li>fail</li>"
    html +=
      "<li class='image-item' id='#{data[i]._id}'>" +
      "<ul class='set-image-kind'>#{setImage}</ul>" +
      "<img src='#{data[i].image_url}' class='pf-image' />" +
      "</li>"
  list.append(html).show()

showImageAdded = ->
  $('#messaging').html('Image added!')

switchImageKind = (el) ->
  console.log el
  $('#messaging').html('Image changed!')

$('body').on 'click', '.changeImageKind', (e) ->
  e.preventDefault()
  $this = $(this)
  id = $(this).parent('li').parent('ul').parent('li').attr('id')
  data =
    kind: if $(this).hasClass 'isPass' then 'fail' else 'pass'
  $.ajax
    type: 'PUT'
    url: 'api/images/' + id
    success: switchImageKind $this
    contentType: 'application/json'
    data: JSON.stringify(data)

imageForm = $('#js-add-image')

imageForm.on 'submit', (e) ->
  e.preventDefault()
  data =
    image_url: imageForm.find('#imageUrl').val()
    kind: imageForm.find('input[name=kind]:checked').val()
  $.ajax
    type: 'POST'
    url: 'api/images'
    success: showImageAdded
    contentType: 'application/json'
    data: JSON.stringify(data)

$('#js-show-images').on 'click', ->
  $(this).remove()
  $.ajax
    type: 'GET'
    url: 'api/images'
    success: displayImages
    dataType: 'json'
