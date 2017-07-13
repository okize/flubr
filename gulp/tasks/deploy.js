const gulp = require('gulp');
const git = require('gulp-git');

const log = require('../helpers/log');
const getPak = require('../helpers/getPackageJson');

// deploys app to heroku
gulp.task('deploy-app', () => {
  const pak = getPak(true);
  const logMessage = `Pushed v${pak.version} to Heroku`;

  return git
    .push('heroku', 'master', null, () => log.info(logMessage))
    .end();
});
