const path = require('path');
const gulp = require('gulp');
const bg = require('gulp-bg');
const nodemon = require('gulp-nodemon');
const liveReload = require('tiny-lr')();
const config = require('../config');
const log = require('../helpers/log');

// sends updated files to LiveReload server
const refreshPage = (event) => {
  const fileName = path.relative(config.root, event.path);
  log.info(`${fileName} changed`);
  return liveReload.changed({ body: { files: [fileName] } });
};

// DO NOT restart node app when files change in these directories
const appIgnoreDirs = [
  '.git',
  'node_modules/**',
  'gulp/**',
  'tests/**',
  'views/**',
];

// watches source files and triggers a page refresh on change
gulp.task('watch', () => {
  const dirsToWatch = [
    config.src.app,
    config.src.templates,
    config.src.stylus,
    config.src.js,
  ];
  return gulp.watch(dirsToWatch, refreshPage);
});

// starts up mongo
gulp.task('start-mongo', bg('mongod', '--quiet'));

// starts up LiveReload server and the app with nodemon
gulp.task('start-app', () => {
  log.info('Starting application server');
  return nodemon({
    script: config.main,
    env: process.env,
    nodeArgs: [`--inspect=${process.env.DEBUG_PORT || 5858}`],
    ignore: appIgnoreDirs,
  }).on('restart', () => log.info('app restarted')).on('start', () => {
    const liveReloadPort = process.env.LIVE_RELOAD_PORT || 35729;
    liveReload.listen(liveReloadPort);
    return log.info(`livereload started on port ${liveReloadPort}`);
  }).on('quit', () => {
    liveReload.close();
    return log.info('app closed');
  });
});
