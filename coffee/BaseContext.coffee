require './initDB'
models = require '../model'
{ db } = require '../config'
{ ObjectId } = require('mongodb')
###
# 上下文基础接口
# 对逻辑进行二次封装，避免高层模块对业务对象的直接调用
###
class BaseContext
	db: ""
	dao: null
	document: ""
	constructor: (@db, @document)->
		# option = {}
		# option[@db] = @document
		# @dao = new MongoDao db, option
	selectOne: (filter, callback)->
		return callback "invalid param" unless filter
		# @dao[@db][@document].selectOne filter, callback
		models.get(@document).findOne filter, callback
	selectList: (filter, callback)->
		return callback "invalid param" unless filter
		# @dao[@db][@document].selectList filter, callback
		models.get(@document).find filter, callback
	insert: (data, callback)->
		return callback "invalid param" unless data
		# @dao[@db][@document].insert data, callback
		models.get(@document).create data, callback
	update: (param, callback)->
		return callback "invalid param" unless param and param.filter
		# @dao[@db][@document].update param.filter, param.setter, callback
		models.get(@document).update param.filter, param.setter, callback
	addOrUpdate: (docs, callback)->
		return callback "invalid param" unless docs
		# @dao[@db][@document].addOrUpdate docs, callback
		that = @
		if Array.isArray docs
			async.each docs, (doc, ccb)->
				models.get(that.document).findOne {_id: doc._id}, (err, result)->
					if result
						models.get(that.document).updateOne {_id: doc._id}, {$set: doc}, ccb
					else
						models.get(that.document).create doc, ccb
			, (err)->
				callback err
		else if docs instanceof Object
			models.get(that.document).findOne {_id: docs._id}, (err, result)->
				if result
					models.get(that.document).updateOne {_id: docs._id}, {$set: docs}, (err)->
						db?.close?()
						callback err
				else
					models.get(that.document).create docs, (err)->
						callback err
	delete: (filter, callback)->
		return callback "invalid param" unless filter
		# @dao[@db][@document].delete filter, callback
		models.get(@document).delete filter, callback
	# selectBySortOrSkipOrLimit: (param, callback) ->
	# 	return callback "invalid param" unless param and param.filter and +param.limit
	# 	return callback "invalid param" if param.skip != 0 && !param.skip
	# 	@dao[@db][@document].selectBySortOrSkipOrLimit param.filter, param.sort, +param.skip, +param.limit, callback
	# selectBySortOrLimit: (param, callback) ->
	# 	return callback "invalid param" unless param and param.filter
	# 	@dao[@db][@document].selectBySortOrLimit param.filter, param.sort, +param.limit || -1, callback
	count: (filter, callback) ->
		return callback "invalid param" unless filter
		# @dao[@db][@document].count filter, callback
		models.get(@document).count filter, callback
module.exports = BaseContext
