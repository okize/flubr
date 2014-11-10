# this file boostraps all the gulp tasks

# load env vars here so they'll be available to all gulp tasks
dotenv = require('dotenv').load()

config = require './config'
tasks = require './helpers/getTaskList'

# load all the gulp task modules
tasks().forEach (task) ->
  require "#{config.taskDir}#{task}"
