
fs    = require 'fs'
path  = require 'path'
_     = require 'lodash'

recursiveRead = (filepath, options) ->
  stat = fs.statSync filepath
  if stat.isDirectory()
    names = fs.readdirSync filepath
    names = names.filter (name) ->
      return false if name[0] is '.'
      return false if name in options.ignoreDirs
      true
    names = names.map (name) -> path.join filepath, name
    names = names.map (name) -> recursiveRead name, options
    names
  else
    [filepath]

exports.recursiveRead = (filepath, options) ->
  tree = recursiveRead filepath, options
  _.flatten tree

