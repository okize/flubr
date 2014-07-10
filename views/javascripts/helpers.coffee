# jquery has to be assigned to window for velocity to work (as of 0.5.1)
$ = window.jQuery = window.$ = require 'jquery'
velocity = require 'velocity-animate'
velocityui = require 'velocity-animate/velocity.ui'
moment = require 'moment'

module.exports =

  animate: ($el, type, cb) ->
    switch type
      when 'pop' then $el.velocity 'callout.pulse', 350, cb
      when 'delete' then $el.velocity 'transition.flipBounceYOut', 500, cb
      when 'addRow' then $el.velocity 'transition.slideDownIn', 500, cb
      when 'deleteRow' then $el.velocity 'transition.slideDownOut', 500, cb

  formatTime: (date) ->
    moment(date).format('lll')
