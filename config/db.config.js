let configure;

if (/production|prod/.test(process.env.NODE_ENV)) {
  configure = {
    "username": "xfq",
    "password": "xfq123456",
    "dbname": "blogdb",
    "hostName": "39.100.241.41",
    "port": "27017",
    "auth": "authSource=blogdb",
    "DB_OPTS": {
      "useNewUrlParser": true,
      "useUnifiedTopology": true
    }
  }
} else {
  configure = {
    "username": "test",
    "password": "test",
    "dbname": "test",
    "hostName": "localhost",
    "port": "27017",
    "auth": "authSource=admin",
    "DB_OPTS": {
      "useNewUrlParser": true,
      "useUnifiedTopology": true
    }
  }
}

module.exports = configure
