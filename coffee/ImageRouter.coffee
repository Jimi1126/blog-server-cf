
multer = require "multer"

# 文件上传
storage = multer.diskStorage({
  destination: (req, file, cb)->
    cb null, path.join(__workspace, 'uploads/')
  filename: (req, file, cb)->
    fieldname = __utils.uuid()
    cb null, fieldname + file.originalname.substring(file.originalname.indexOf('.'))
});

upload = multer { storage: storage } 

module.epxorts = (router, context)->
  router.post __utils.getRouterPath("/store"), upload.single('image'), (req, res)->
    file = req.file
    file.uploadTime = moment().format "YYYY-MM-DD HH:mm:ss"
    context.create file, (err)->
      if err
        LOG.error err
      __utils.generalResult res, err, Number(!err), file.filename