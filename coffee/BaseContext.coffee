models = require '../model'
{ db } = require '../config'
{ ObjectId } = require('mongodb')
###
# 上下文基础接口
# 对逻辑进行封装，避免高层模块对业务对象的直接调用
###
class BaseContext
	constructor: (tableName, dbName)->
		@tableName = tableName or ""
		@dbName = dbName or ""
		@dao = models.get(@tableName) or {}
	###
	# 返回一个代理对象，包含mongoose-model的方法与自定义的处理方法
	###
	proxy: ()->
		new Proxy(@, {
			set: (target, propKey, value, receiver)->
				if propKey in ['tableName', 'dbName', 'dao']
					throw new Error "can't change #{propKey} in #{target.tableName} table DAO"
				Reflect.set target, propKey, value, receiver
			get: (target, propKey)->
				if target[propKey]
					if Object.prototype.toString.call(target[propKey]) is '[object Function]'
						return target[propKey].bind target
					return target[propKey]
				if target.dao[propKey]
					if Object.prototype.toString.call(target.dao[propKey]) is '[object Function]'
						return target.dao[propKey].bind target.dao
					return target.dao[propKey]
				throw new Error "can't find #{propKey} in #{target.tableName} table DAO"
		})
	addOrUpdate: (docs, callback)->
		return callback "invalid param" unless docs
		that = @
		if Array.isArray docs
			async.each docs, (doc, ccb)->
				that.dao.findOne {_id: doc._id}, (err, result)->
					if result
						that.dao.updateOne {_id: doc._id}, {$set: doc}, ccb
					else
						that.dao.create doc, ccb
			, (err)->
				callback err
		else if docs instanceof Object
			that.dao.findOne {_id: docs._id}, (err, result)->
				if result
					that.dao.updateOne {_id: docs._id}, {$set: docs}, (err)->
						callback err
				else
					that.dao.create docs, (err)->
						callback err

module.exports = BaseContext
