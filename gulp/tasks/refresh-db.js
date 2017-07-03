const gulp = require('gulp');
const moment = require('moment');
const mkdirp = require('mkdirp');
const run = require('gulp-run');
const config = require('../config');
const log = require('../helpers/log');
const parseMongoUrl = require('../helpers/parseMongoUrl');

// download production db and import to localdb (logout first)
gulp.task('refresh-db', () => {
  const devDb = parseMongoUrl(process.env.MONGODB_DEV_URL);
  const { host, port, database, username, password } = parseMongoUrl(process.env.MONGODB_PROD_URL || process.env.MONGOHQ_URL);
  const dateStamp = moment().format('YYYYMMDD-hhmmss');
  const dumpDir = `${config.root}/dump/${dateStamp}`;
  const mongoDumpCmd = `mongodump --host ${host}:${port} --db ${database} -u ${username} -p${password} -o ${dumpDir}`;
  const mongoRestoreCmd = `mongorestore --drop -d ${devDb.database} ${dumpDir}/${devDb.database}`;
  return mkdirp(dumpDir, (err) => {
    if (err) { throw err; }
    return run(mongoDumpCmd).exec(() => run(mongoRestoreCmd).exec(() => log.info('database downloaded from production and imported to development')));
  });
});
