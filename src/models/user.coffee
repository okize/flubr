mongoose = require 'mongoose'

User = new mongoose.Schema(
  userid: String
  userName: String
  displayName: String
  avatar: String
  created_at: { type: Date, default: Date.now }
)

module.exports = mongoose.model 'User', User
