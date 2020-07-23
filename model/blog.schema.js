const { Schema } = require('mongoose');
const Tag = require('./tag.schema')

module.exports = new Schema({
  catalog: String,
  title: String,
  desc: String,
  author: String,
  publish: Boolean,
  tags: [Tag],
  cover: String
})