# download production db and import to localdb (logout first)

gulp = require 'gulp'
moment = require 'moment'
mkdirp = require 'mkdirp'
run = require 'gulp-run'
config = require '../config'
log = require '../helpers/log'
parseMongoUrl = require '../helpers/parseMongoUrl'

gulp.task 'refresh-db', ->
  devDb = parseMongoUrl process.env.MONGODB_DEV_URL
  prodDb = parseMongoUrl process.env.MONGODB_PROD_URL || process.env.MONGOHQ_URL
  dateStamp = moment().format('YYYYMMDD-hhmmss')
  dumpDir = "#{config.root}/dump/#{dateStamp}"
  mongoDumpCmd = "mongodump --host #{prodDb.host}:#{prodDb.port}
    --db #{prodDb.database} -u #{prodDb.username}
    -p#{prodDb.password} -o #{dumpDir}"
  mongoRestoreCmd = "mongorestore --drop -d #{devDb.database} #{dumpDir}/#{devDb.database}"
  mkdirp(dumpDir, (err) ->
    throw err if err
    run(mongoDumpCmd)
    .exec( ->
      run(mongoRestoreCmd).exec( ->
        log.info 'database downloaded from production and imported to development'
      )
    )
  )
