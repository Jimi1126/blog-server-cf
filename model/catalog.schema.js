const { Schema } = require('mongoose');

module.exports = new Schema({
  pcode: String,
  code: String,
  name: String
})