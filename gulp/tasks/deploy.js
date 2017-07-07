// deploys app to heroku

const gulp = require('gulp');
const git = require('gulp-git');

const log = require('../helpers/log');
const getPak = require('../helpers/getPackageJson');

gulp.task('deploy-app', () => {
  const pak = getPak(true);

  return git
    .push(
      'heroku',
      'master',
      null,
      () => log.info(`Pushed v${pak.version} to Heroku`))
    .end();
});
