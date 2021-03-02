import json from 'rollup-plugin-json';
import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import node_globals from 'rollup-plugin-node-globals';
import coffeescript from 'rollup-plugin-coffee-script';
import { terser } from 'rollup-plugin-terser';
import pkg from './package.json'

export default {
  input: './coffee/main.coffee',
  output: [
    { file: pkg.main, format: 'cjs' }
  ],
  plugins: [
    json(),
    // node_globals(),
    coffeescript(),
    resolve({
      extensions: ['.js', '.coffee'],
      // 将自定义选项传递给解析插件
      customResolveOptions: {
        moduleDirectory: 'node_modules'
      }
    }),
    commonjs({
      extensions: ['.js', '.coffee']
    }),
    // terser()
  ],
  // 指出应将哪些模块视为外部模块
  external: Object.keys(pkg.dependencies).concat(["async"])
}