const { Schema } = require('mongoose');

module.exports = new Schema({
  blog: String,
  content: String,
  html: String
})