const { Schema } = require('mongoose');

module.exports = new Schema({
  essay: String,
  author: String,
  content: String
})