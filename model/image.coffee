mongoose = require 'mongoose'
random = require 'mongoose-random'

Image = new mongoose.Schema(
  image_url: String
  original_url: String
  kind: { type: String, default: 'neutral' }
  added_by: String
  randomizer: { type: Number, default: Math.random() }
  created_at: { type: Date, default: Date.now }
)
Image.plugin random()

mongoose.model 'Image', Image