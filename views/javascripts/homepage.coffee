getImage = (image) ->
  xhr = new XMLHttpRequest()
  xhr.open 'GET', "/api/images/random/#{image.kind}"
  xhr.send null
  xhr.onreadystatechange = ->
    if xhr.readyState == 4
      if xhr.status == 200
        image.el.innerHTML = "<img src='#{xhr.responseText}' />"
        image.el.offsetParent.style.visibility = 'visible'

images = [
  { kind: 'pass', el: document.getElementById 'random-pass-image' }
  { kind: 'fail', el: document.getElementById 'random-fail-image' }
]

getImage image for image in images
