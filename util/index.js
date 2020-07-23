const fs = require('fs')
const path = require('path')

exports.load_module = (dir, regexp, deep) => {
  const dirs = fs.readdirSync(dir)
  const reg = new RegExp(regexp)
  const modules = {}
  dirs.forEach(dnm => {
    if (reg.test(dnm)) {
      try {
        modules[dnm] = require(path.resolve(dir, dnm))
      } catch (error) {
        console.error(error.message)
      }
    }
  });
  const __nms = Object.keys(modules)
  modules.keys = function () {
    return __nms
  }
  return modules;
}