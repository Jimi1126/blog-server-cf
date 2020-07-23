express = require "express"
bodyParser = require 'body-parser'
cookieParser = require "cookie-parser"
session = require "express-session"
multer = require "multer"
marked = require "marked"
ObjectId = require('mongodb').ObjectId
ExecHandler = require "./ExecHandler"
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
		# 文件上传
		storage = multer.diskStorage({
			destination: (req, file, cb)->
				cb null, path.join(__workspace, 'uploads/')
			filename: (req, file, cb)->
				fieldname = __utils.uuid()
				cb null, fieldname + file.originalname.substring(file.originalname.indexOf('.'))
		});
		upload = multer { storage: storage } 
		new GeneralRouter("catalog").router()
		new GeneralRouter("blog").router()
		new GeneralRouter("tag").router()
		new GeneralRouter("essay").router()
		new GeneralRouter("comment").router()
		new GeneralRouter("image").router (router, context)->
			router.post __utils.getRouterPath("/store"), upload.single('image'), (req, res)->
				file = req.file
				file.uploadTime = moment().format "YYYY-MM-DD HH:mm:ss"
				context.insert file, (err)->
					if err
						LOG.error err
					__utils.generalResult res, err, Number(!err), file.filename

module.exports = Router
