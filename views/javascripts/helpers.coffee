# jquery has to be assigned to window for velocity to work (as of 0.5.1)
$ = window.jQuery = window.$ = require 'jquery'
velocity = require 'velocity-animate'
velocityui = require 'velocity-animate/velocity.ui'
moment = require 'moment'

module.exports =

  animate: ($el, type, cb) ->
    switch type
      when 'pop' then $el.velocity('callout.pulse', 350)
      when 'delete' then $el.velocity('transition.flipBounceYOut', 500)
      when 'addRow' then $el.velocity('transition.slideDownIn', 500)
      when 'deleteRow' then $el.velocity('transition.slideDownOut', 500)

  formatTime: (date) ->
    moment(date).format('lll')
