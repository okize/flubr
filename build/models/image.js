var Image, mongoose;

mongoose = require('mongoose');

Image = new mongoose.Schema({
  image_url: String,
  thumbnail_url: String,
  original_url: String,
  animated: {
    type: Boolean,
    "default": false
  },
  kind: {
    type: String,
    "default": 'neutral'
  },
  deleted: {
    type: Boolean,
    "default": false
  },
  added_by: String,
  updated_by: String,
  deleted_by: String,
  created_at: {
    type: Date,
    "default": Date.now
  }
});

module.exports = mongoose.model('Image', Image);
