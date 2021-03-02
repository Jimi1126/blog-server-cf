const mongoose = require('mongoose');
const util = require('../util');
const LOG = __logger.getLogger("mongoose-model");

const models = {};
LOG.info(`正在从【${__dirname}】加载schema...`);
const start = moment()
const schemas = util.load_module(global.path.resolve(__workspace, 'model'), /\.schema\.js$/);
schemas.keys().forEach((nm) => {
  if (schemas[nm] instanceof mongoose.Schema) {
    const name = nm.replace(/\.schema\.js$/, "");
    schemas[nm].set('timestamps', true)
    models[name] = mongoose.model(name, schemas[nm])
    LOG.info(`加载${nm}成功`);
  } else {
    LOG.error(`${nm}导出不是schema，赶紧查查`);
  }
});
LOG.info(`---- 加载schema成功 ---- ${moment() - start}ms`);

models.get = function (name) {
  if (!this[name])
    this[name] = mongoose.model(name, new mongoose.Schema({}))
  return this[name]
}

module.exports = models;
