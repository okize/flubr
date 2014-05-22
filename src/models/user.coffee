mongoose = require 'mongoose'

User = new mongoose.Schema(
  userid: String
  name: String
  image: String
  created_at: { type: Date, default: Date.now }
)

module.exports = mongoose.model 'User', User
