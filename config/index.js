const util = require('../util');
const configures = {};

const config_components = util.load_module(global.path.resolve(__workspace, 'config'), /\.config\.js$/);

config_components.keys().forEach((nm) => {
  const config = config_components[nm]
  configures[nm.replace(/\.config\.js$/, "")] = config
});

module.exports = configures;
