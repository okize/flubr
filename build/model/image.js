var Image, mongoose;

mongoose = require('mongoose');

Image = new mongoose.Schema({
  image_url: String,
  original_url: String,
  kind: {
    type: String,
    "default": 'neutral'
  },
  added_by: String,
  created_at: {
    type: Date,
    "default": Date.now
  }
});

mongoose.model('Image', Image);
