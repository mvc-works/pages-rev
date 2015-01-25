
path = require 'path'
scanner = require './scanner'
dir = require './util/dir'
_ = require 'lodash'

exports.run = (options) ->
  files = dir.recursiveRead options.base, options
  registry = {}
  entries = options.entries.map (name) ->
    path.join options.base, name
  options.templateExtnames = _.unique entries.map (entry) ->
    extname = path.extname entry
  entries.forEach (entry) ->
    scanner.scan entry, files, registry, options
  console.log registry
