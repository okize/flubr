module.exports = ($) ->

  # homepage random images
  getRandomImage = (el, type) ->
    $.get '/api/images/random/' + type, (data) ->
      el.append "<img src='#{data}' />"

  randomPassImage = $('#random-pass-image')
  randomFailImage = $('#random-fail-image')

  if randomPassImage.length and randomFailImage.length
    getRandomImage randomPassImage, 'pass'
    getRandomImage randomFailImage, 'fail'
