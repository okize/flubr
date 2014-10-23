# this file boostraps all the gulp tasks

config = require './config'
tasks = require './helpers/getTaskList'

# load all the gulp task modules
tasks().forEach (task) ->
  require "#{config.taskDir}/#{task}"
