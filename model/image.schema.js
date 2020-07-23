const { Schema } = require('mongoose');

module.exports = new Schema({
  originalname: String,
  encoding: String,
  mimetype: String,
  destination: String,
  filename: String,
  path: String,
  size: Number
})