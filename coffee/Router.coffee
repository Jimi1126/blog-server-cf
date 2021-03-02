express = require "express"
bodyParser = require 'body-parser'
cookieParser = require "cookie-parser"
session = require "express-session"
marked = require "marked"
GeneralRouter = require "./GeneralRouter"
LOG = __logger.getLogger "Router"

class Router
	constructor: ->
		@preRouter()
	preRouter: ->
		app.use __utils.getRouterPath('/file'), express.static(path.join(__workspace, 'uploads/'))
		app.set 'view engine', 'html'
		app.use cookieParser()
		app.use session({
			secret: "blog"
			resave: true
			key: "blog"
			saveUninitialized: true
			rolling: false
			cookie: {
				secure: false # http有效
				maxAge: 5 * 60 * 1000
			}
		})
		###
		# 开启跨域，便于接口访问.
		###
		app.all '*', (req, res, next) ->
			res.header 'Access-Control-Allow-Origin', '*' #控制访问来源：所有
			res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept' #访问控制允许报头 X-Requested-With: xhr请求 
			res.header 'Access-Control_Allow-Metheds', 'GET, POST, PUT, DELETE, OPTIONS' #访问控制允许方法 
			res.header 'X-Powered-By', 'nodejs' #自定义头信息，表示服务端用nodejs 
			res.header 'Content-Type', 'application/json;charset=utf-8'
			next()
	router: ->
		app.use bodyParser.json()
		app.use bodyParser.urlencoded {extended: true}

		@loadBusinessRoute()

		app.use logErrors
		app.use clientErrorHandler
		app.use errorHandler

	loadBusinessRoute: ->
		files = fs.readdirSync path.resolve(__workspace, 'model')
		files.forEach (file)=>
			if /\.schema\.js$/.test file
				name = file.replace /\.schema\.js$/, ""
				try
					middlewareNM = "./" + __utils.upperFirstStr name + "Router"
					router = require middlewareNM
				catch e
					LOG.warn "Cannot find #{name} router 中间件"
				new GeneralRouter(name).router(router)
		
	logErrors = (err, req, res, next)->
		console.error err.stack
		next(err)

	clientErrorHandler = (err, req, res, next)->
		if req.xhr
			res.status(500).send({ error: 'Something failed!' })
		else
			next(err)

	errorHandler = (err, req, res, next)->
		res.status(500).send({ error: 'Something failed!' })

module.exports = Router
