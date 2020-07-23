let configure;

if (/production|prod/.test(process.env.NODE_ENV)) {
  configure = {
    "replaceConsole": true,
    "appenders": {
      "console": {
        "type": "console"
      },
      "http": {
        "type": "dateFile",
        "filename": "/node/logs/",
        "pattern": "http-yyyyMMdd.log",
        "alwaysIncludePattern": true
      },
      "error": {
        "type": "file",
        "filename": "/node/logs/",
        "pattern": "error-yyyyMMdd.log",
        "alwaysIncludePattern": true
      },
      "default": {
        "type": "dateFile",
        "filename": "/node/logs/",
        "pattern": "server-yyyyMMdd.log",
        "alwaysIncludePattern": true
      },
      "logFilter": {
        "type": "logLevelFilter",
        "appender": "error",
        "level": "error"
      }
    },
    "categories": {
      "default": {
        "appenders": [
          "console"
        ],
        "level": "all"
      },
      "HTTP": {
        "appenders": [
          "http"
        ],
        "level": "all"
      },
      "module": {
        "appenders": [
          "console",
          "default",
          "logFilter"
        ],
        "level": "all"
      }
    }
  }
} else {
  configure = {
    "replaceConsole": true,
    "appenders": {
      "console": {
        "type": "console"
      }
    },
    "categories": {
      "default": {
        "appenders": [
          "console"
        ],
        "level": "all"
      },
      "module": {
        "appenders": [
          "console"
        ],
        "level": "all"
      }
    }
  }
}

module.exports = configure
