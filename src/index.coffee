
path = require 'path'
scanner = require './scanner'
dir = require './util/dir'

exports.run = (options) ->
  files = dir.recursiveRead options.base, options
  registry = {}
  entries = options.entries.map (name) ->
    path.join options.base, name
  entries.forEach (entry) ->
    scanner.scan entry, options.base, files, registry
  console.log registry
