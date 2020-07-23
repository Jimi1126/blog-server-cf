let configure;

if (/production|prod/.test(process.env.NODE_ENV)) {
  configure = {
    autoIndex: true, // 文档索引
    reconnectTries: Number.MAX_VALUE, // 重连次数
    reconnectInterval: 500, // 重连间隔ms
    poolSize: 10 // 线程池
  }
} else {
  configure = {
    reconnectTries: 100, // 重连次数
    reconnectInterval: 500, // 重连间隔ms
    poolSize: 5, // 线程池
    bufferMaxEntries: 0 // 离线时缓存机制，如果连接不成功，则终止数据库操作立即返回错误，而不是等待重新连接
  }
}

module.exports = configure
