# small wrapper for gulp logging

gutil = require 'gulp-util'
prettyHrtime = require 'pretty-hrtime'
startTime = undefined

module.exports =

  # info logging
  info: (msg) ->
    gutil.log gutil.colors.blue(msg)

  # error logging
  error: (err) ->
    if err.name and err.stack
      err = gutil.colors.red("#{err.plugin}: #{err.name}: ") +
            gutil.colors.bold.red("#{err.message}") +
            "\n#{err.stack}"
    else
      err = gutil.colors.red err
    gutil.log err

  # outputs ascii logo
  logo: () ->
    console.log "   __  _         _"
    console.log "  / _|| |       | |"
    console.log " | |_ | | _   _ | |__   _ __"
    console.log " |  _|| || | | || '_ \\ | '__|"
    console.log " | |  | || |_| || |_) || |"
    console.log " |_|  |_| \\__,_||_.__/ |_|"

  # start logging with timer
  start: (msg) ->
    startTime = process.hrtime()
    gutil.log gutil.colors.blue(msg)

  # displays task time since timer started
  end: (task) ->
    taskTime = prettyHrtime process.hrtime(startTime)
    gutil.log 'Finished', gutil.colors.cyan(task),
              'after', gutil.colors.magenta(taskTime)
