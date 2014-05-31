getImageSetHtml = (imageKind) ->
  if imageKind == 'pass'
    "<li>pass</li><li><a href='#' class='changeImageKind isPass'>fail</a></li>"
  else
    "<li><a href='#' class='changeImageKind isFail'>pass</a></li><li>fail</li>"

getThumbnail = (url) ->
  thumbnail = (url.substring(0, url.length - 4)) + 's.jpg'

displayImages = (data) ->
  list = $('#js-image-list')
  html = ''
  $.each data, (i) ->
    html +=
      "<li class='image-item' id='#{data[i]._id}'>" +
      "<ul class='set-image-kind'>#{getImageSetHtml(data[i].kind)}</ul>" +
      "<img src='#{getThumbnail(data[i].image_url)}' class='pf-image' />" +
      "<div class='delete-image'><a href='#'>delete</a></div>" +
      "</li>"
  list.append(html).show()

showImageAdded = ->
  $('#messaging').html('Image added!')

switchImageKind = (el, newKind) ->
  el.closest('.set-image-kind').html( getImageSetHtml newKind )
  $('#messaging').html('Image kind changed!')

deleteImageInUi = (el) ->
  el.closest('.image-item').remove()
  $('#messaging').html('Image deleted!')

$('body').on 'click', '.changeImageKind', (e) ->
  e.preventDefault()
  $this = $(this)
  id = $this.closest('.image-item').attr('id')
  data =
    kind: if $this.hasClass 'isPass' then 'fail' else 'pass'
  $.ajax
    type: 'PUT'
    url: 'api/images/' + id
    success: switchImageKind $this, data.kind
    contentType: 'application/json'
    data: JSON.stringify(data)

$('body').on 'click', '.delete-image a', (e) ->
  e.preventDefault()
  verify = confirm 'Are you sure you want to delete this image?'
  if verify == true
    $this = $(this)
    id = $this.closest('.image-item').attr('id')
    $.ajax
      type: 'DELETE'
      url: 'api/images/' + id
      success: deleteImageInUi $this
      contentType: 'application/json'

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
