// output some stats about image data

const path = require('path');
const gulp = require('gulp');
const _ = require('lodash');
const config = require('../config');
const log = require('../helpers/log');
const Image = require(`${config.root}/src/models/image`);
const mongoose = require('mongoose');

gulp.task('stats', () => {
  const db = process.env.MONGODB_PROD_URL || process.env.MONGOHQ_URL;
  return mongoose.connect(db, (err) => {
    if (err) { throw err; }
    return Image.find({ deleted: false }).exec(
      (err, results) => {
        if (err) { throw err; }
        let passImageCount = 0;
        let failImageCount = 0;
        const images = _.map(results, (image) => {
          if (image.kind === 'pass') { passImageCount++; }
          if (image.kind === 'fail') { return failImageCount++; }
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
