express = require "express"
BaseContext = require './BaseContext'
LOG = __logger.getLogger "GeneralRouter"
class GeneralRouter
	name: ""
	dbname: ""
	constructor: (@name, dbname)->
		@dbname = (dbname or global.dbname)
	router: (middleware)->
		if !@name
			LOG.error "存在未创建路由，原因：未传入路由器名称"
			return
		router = express.Router()
		try
			contextName = "./" + __utils.upperFirstStr @name + "Context"
			contextProxy = new (require contextName)(@name, @dbname)?.proxy?()
		catch e
			LOG.warn "Cannot find module '#{contextName}'，转用通用Context，如果是名称#{@name}有误，请马上修正并在数据库清除该名称的表"
			contextProxy = new BaseContext(@name, @dbname)?.proxy?()
		# 新增资源
		router.post '/', (req, res)-> 
			contextProxy.create req.body, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		# 删除资源
		router.delete '/:_id', (req, res)-> 
			contextProxy.deleteOne req.params, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		# 更新资源
		router.put '/:_id', (req, res)->
			contextProxy.updateOne {_id: req.params._id}, req.body, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		# 获取单个资源
		router.get '/:_id', (req, res)-> 
			contextProxy.findOne req.params, (err, doc)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err), doc
		# 获取多个资源
		router.get '/', (req, res)-> 
			contextProxy.find req.query, (err, docs)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err), docs
		try
			middleware?(router, contextProxy)
		catch e
			LOG.error "'#{contextName}'的中间件不可用"
		app.use __utils.getRouterPath() + @name, router
module.exports = GeneralRouter
