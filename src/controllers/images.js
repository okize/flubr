const path = require('path');
const _ = require('lodash');
const help = require(path.join('..', 'helpers'));
const Image = require(path.join('..', 'models', 'image'));
const request = require('request');
const async = require('async');

const checkUrlIsImage = url => url.match(/\.(jpeg|jpg|gif|png)$/) !== null;

const errors = {
  needToLogin: 'Action requires user to be authenticated',
  noIdError: 'Please specify image type (pass/fail) in request url',
  noImageError: 'No image found',
  noImageUrlSent: 'No image url specified',
  noImageUrlReturned: 'Something went wrong and your image could not be saved. Please try again.',
  invalidImageUrl: 'That does not appear to be a valid image url'
};

// image model's CRUD controller.
module.exports = {

  // lists all images
  index(req, res) {
    return Image.find({deleted: false}).sort({created_at: 'descending'}).exec(
      function(err, results) {
        if (err != null) { res.send(500, {error: err}); }
        return res.send(results);
    });
  },

  // lists all deleted images
  indexDeleted(req, res) {
    return Image.find({deleted: true}).sort({created_at: 'descending'}).exec(
      function(err, results) {
        if (err != null) { res.send(500, {error: err}); }
        return res.send(results);
    });
  },

  // displays single image
  show(req, res) {
    return Image.findById(req.params.id, function(err, result) {
      if (err != null) { res.send(500, {error: err}); }
      return res.send(result);
    });
  },

  // returns random image url based on id of pass/fail
  random(req, res) {
    if ((req.params.id == null) || !req.params.id.match(/(pass|fail)/g)) {
      res.send(500, {error: errors.noIdError});
    }
    return Image.find({
      kind: req.params.id,
      deleted: false
    }
    , 'image_url', function(err, results) {
      if (err != null) { res.send(500, {error: err}); }
      const randomImage = _.sample(results);
      if (!(randomImage == null)) {
        return res.send(randomImage.image_url);
      } else {
        return res.send(500, {error: errors.noImageError});
      }
    });
  },

  // creates new image record
  create(req, res)  {
    if (help.checkForUser(req, res)) {

      const url = (req.body.source_url).trim();

      if ((url === undefined) || (url === '')) {
        return res.send(422, {error: errors.noImageUrlSent});
      } else if (!checkUrlIsImage(url)) {
        return res.send(422, {error: errors.invalidImageUrl});
      } else {
        return async.series([
          function(callback) {

            if (!url.match(/imgur.com/)) {
              let data = {
                image: url,
                type: 'url'
              };
              const options = {
                url: 'https://api.imgur.com/3/image',
                headers: {
                  Authorization: `Client-ID ${process.env.IMGUR_CLIENTID}`,
                  'Content-Type': 'application/x-www-form-urlencoded',
                  Accept: 'application/json'
                }
              };

              return request.post(
                options,
                function(err, response, body) {
                  data = JSON.parse(body);
                  if (err) {
                    return callback(err, null);
                  } else if (!data.success) {
                    return callback(data.data.error, null);
                  } else if ((data.data.link == null)) {
                    return callback(errors.noImageUrlReturned, null);
                  } else {
                    return callback(null, data.data.link);
                  }
              }).form(data);

            } else {
              return callback(null, url);
            }
          }

        ], function(err, results) {
          if (err != null) {
            return res.send(500, {error: err});
          } else {
            req.body.added_by = req.user.userid;
            req.body.image_url = results[0];
            const img = new Image(req.body);
            return img.save(function(err, results) {
              if (err != null) { res.send(500, {error: err}); }
              return res.send(201, results);
            });
          }
        });
      }

    } else {
      return res.send(401, {error: errors.needToLogin});
    }
  },

  // updates existing image record type: pass or fail
  update(req, res) {
    if (help.checkForUser(req, res)) {
      const updateData = {
        kind: req.body.kind,
        updated_by: req.user.userid
      };
      return Image.update({_id: req.params.id}, updateData, function(err, count) {
        if (err != null) { res.send(500, {error: err}); }
        return res.send(200, {success: `${count} rows have been updated`});
      });
    } else {
      return res.send(401, {error: errors.needToLogin});
    }
  },

  // deletes image record non-permanently
  delete(req, res) {
    if (help.checkForUser(req, res)) {
      const updateData = {
        deleted: true,
        deleted_by: req.user.userid
      };
      return Image.update({_id: req.params.id}, updateData, function(err, count) {
        if (err != null) { res.send(500, {error: err}); }
        return res.send(200, {success: `${count} rows have been deleted`});
      });
    } else {
      return res.send(401, {error: errors.needToLogin});
    }
  }
};
