let configure;

if (/production|prod/.test(process.env.NODE_ENV)) {
  configure = {
    "hostName": "localhost",
    "port": "7788",
    "router_prefix": "/"
  }
} else {
  configure = {
    "hostName": "localhost",
    "port": "7788",
    "router_prefix": "/"
  }
}

module.exports = configure
