const mongo = require('mongoose')
const { db, mongoose } = require('../config')
const LOG = __logger.getLogger("mongoose")

module.exports = function () {
  const url = `mongodb://${db.username}:${db.password}@${db.hostName}:${db.port}/${db.dbname}`;

  mongo.connect(url, { ...db.DB_OPTS, ...mongoose });

  mongo.connection.on('connected', () => {
    LOG.info('connect mongodb success by mongoose@' + mongo.version)
  })

  mongo.connection.on('disconnected', () => {
    LOG.info('disconnected mongodb.')
  })

  mongo.connection.on('error', (err) => {
    LOG.error('mongoose error：' + err.message)
  })
  
}