const fs = require('fs');
const gulp = require('gulp');
const runSequence = require('run-sequence');
const semver = require('semver');
const codename = require('codename')();
const git = require('gulp-git');
const gift = require('gift');

const repo = gift('./');
const getPak = require('../helpers/getPackageJson');
const log = require('../helpers/log');

// commits, tags & pushes master
gulp.task('release', callback => runSequence(['bump-version'], ['tag-version'], ['push-updates'], callback));

// bumps version & commits new package.json
gulp.task('bump-version', () => {
  const pak = getPak(true);

  // create a codename for app release
  pak.releaseCodename = codename.generate(['alliterative', 'random'], ['adjectives', 'animals']).join('');

  // bump patch version of app
  pak.version = semver.inc(pak.version, 'patch');
  fs.writeFileSync('./package.json', JSON.stringify(pak, null, '  '));
  const msg = `Built new release (v${pak.version}) codenamed ${pak.releaseCodename}`;
  return repo.add('./', (error) => {
    if (error) { throw error; }
    return repo.commit(msg, { all: true }, (err) => {
      if (err) { throw err; }
      return log.info(`${msg} & committed to master`);
    });
  });
});

// bumps patch version and creates a new tag
gulp.task('tag-version', () => {
  const pak = getPak(true);

  // creates new tag
  return git
    .tag(
      `v${pak.version}`,
      `Release codename: ${pak.releaseCodename}`,
      { args: ' --annotate' },
      () => log.info(`Tagged version ${pak.version}`));
});

// push commits to github
gulp.task('push-updates', () => console.log('push updates is broken'));

  // pak = getPak(true)

  // git
  //   .push(
  //     'origin',
  //     'master',
  //     args: ' --tags',
  //     ->
  //       log.info "Pushed v#{pak.version} tag to Github"
  //   )
  //   .end()
