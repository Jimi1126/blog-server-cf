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
			context = new (require contextName)()
		catch e
			LOG.error "Cannot find module '#{contextName}'，转用通用Context，如果是名称#{@name}有误，请马上修正并在数据库清除该名称的表"
			context = new BaseContext @dbname, @name
		## 新增
		router.post "/insert", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.insert param, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		## 查询单个
		router.post "/selectOne", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.selectOne param, (err, doc)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err), doc
		## 查询
		router.post "/selectList", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.selectList param, (err, docs)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err), docs
		## 更新
		router.post "/update", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.addOrUpdate param, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		## 新增或修改
		router.post "/addOrUpdate", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.addOrUpdate param, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		## 删除
		router.post "/delete", (req, res)->
			param = if Object.keys(req.query).length is 0 then req.body else req.query
			context.delete param, (err)->
				if err
					LOG.error err
				__utils.generalResult res, err, Number(!err)
		try
			middleware?(router, context)
		catch e
			LOG.error "'#{contextName}'的中间件不可用"
		app.use __utils.getRouterPath() + @name, router
module.exports = GeneralRouter
