
path = require 'path'
fs = require 'fs'

mkdirp = require 'mkdirp'

exports.write = (registry, options) ->
  {base} = options
  dest = path.join base, options.dest
  # console.log registry
  for filepath, file of registry
    absolutePath = path.join dest, file.finalPath
    dir = path.dirname absolutePath
    mkdirp.sync dir
    fs.writeFileSync absolutePath, file.content, file.encoding
