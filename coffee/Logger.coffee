###
# 日志模块
###
log4js = require "log4js"
{ log } = require '../config'

log4js.configure log
class Logger
	###
	# 默认全局使用default类别
	# 通过传入类名，生成该类类别的日志对象
	###
	getLogger: (category)->
		unless category
			log4js.getLogger "default"
		else if log.categories[category]
			log4js.getLogger category
		else
			name = category.toString().toUpperCase()
			log.categories[name] = log.categories.module
			log4js.configure log
			log4js.getLogger name
	useLogger: (app, logger)->
		app?.use?(log4js.connectLogger(logger || @getLogger(), {
			format: '[:remote-addr :method :url :status :response-timems][:referrer HTTP/:http-version :user-agent]'
		}))

logger = new Logger()
global.LOG = logger.getLogger()
module.exports = logger
