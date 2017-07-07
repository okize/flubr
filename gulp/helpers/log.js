// small wrapper for gulp logging

const gutil = require('gulp-util');
const prettyHrtime = require('pretty-hrtime');
let startTime;

module.exports = {

  // info logging
  info(msg) {
    return gutil.log(gutil.colors.blue(msg));
  },

  // error logging
  error(err) {
    if (err.name && err.stack) {
      err = `${gutil.colors.red(`${err.plugin}: ${err.name}: `) +
            gutil.colors.bold.red(`${err.message}`)
            }\n${err.stack}`;
    } else {
      err = gutil.colors.red(err);
    }
    return gutil.log(err);
  },

  // outputs ascii logo
  logo() {
    console.log('   __  _         _');
    console.log('  / _|| |       | |');
    console.log(' | |_ | | _   _ | |__   _ __');
    console.log(" |  _|| || | | || '_ \\ | '__|");
    console.log(' | |  | || |_| || |_) || |');
    return console.log(' |_|  |_| \\__,_||_.__/ |_|');
  },

  // start logging with timer
  start(msg) {
    startTime = process.hrtime();
    return gutil.log(gutil.colors.blue(msg));
  },

  // displays task time since timer started
  end(task) {
    const taskTime = prettyHrtime(process.hrtime(startTime));
    return gutil.log('Finished', gutil.colors.cyan(task),
              'after', gutil.colors.magenta(taskTime));
  },
};
