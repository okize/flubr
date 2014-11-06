module.exports = (selector) ->

  # replace empty image source with data-src value
  loadImage = (el, cb) ->
    img = new Image()
    src = el.getAttribute('data-src')
    img.onload = ->
      unless imageLoaded el
        el.src = src
        el.className = el.getAttribute('class') + ' loaded'
        if cb then cb() else null
    img.src = src

  # check if image has a class called 'loaded'
  imageLoaded = (el) ->
    el.className.indexOf('loaded') > -1

  # check if image is visible in viewport
  imageInView = (el) ->
    rect = el.getBoundingClientRect()
    rect.top >= 0 and rect.left >= 0 and rect.top <= window.innerHeight

  window.addEventListener 'load', ->
    images = document.querySelectorAll("img.#{selector or 'lazy'}")

    processScroll = ->
      for image in images
        if imageInView image
          loadImage image

    processScroll()

    # register processScroll event
    window.addEventListener 'scroll', processScroll, false
