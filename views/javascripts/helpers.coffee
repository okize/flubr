moment = require 'moment'

module.exports =

  formatTime: (date) ->
    moment(date).format('lll')
