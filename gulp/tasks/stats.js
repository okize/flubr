const gulp = require('gulp');
const mongoose = require('mongoose');

const log = require('../helpers/log');
const Image = require('../../src/models/image');

// output some stats about image data
gulp.task('stats', () => {
  const db = process.env.MONGODB_PROD_URL || process.env.MONGOHQ_URL;
  return mongoose.connect(db, (error) => {
    if (error) { throw error; }
    return Image.find({ deleted: false }).exec((err, results) => {
      if (err) { throw err; }
      let passImageCount = 0;
      let failImageCount = 0;
      results.forEach((image) => {
        if (image.kind === 'pass') { passImageCount += 1; }
        if (image.kind === 'fail') { failImageCount += 1; }
      });
      const totalImageCount = passImageCount + failImageCount;
      const passPercent = ((passImageCount / totalImageCount) * 100).toFixed(1);
      const failPercent = ((failImageCount / totalImageCount) * 100).toFixed(1);
      log.logo();
      log.info(`${totalImageCount} total images`);
      log.info(`${passImageCount} (${passPercent}%) PASS images`);
      log.info(`${failImageCount} (${failPercent}%) FAIL images`);
      return mongoose.disconnect();
    });
  });
});
