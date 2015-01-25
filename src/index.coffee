
path = require 'path'
_ = require 'lodash'

scanner = require './scanner'
dir = require './util/dir'
writer = require './writer'

exports.run = (options) ->
  files = dir.recursiveRead options.base, options
  registry = {}
  entries = options.entries.map (name) ->
    path.join options.base, name
  options.templateExtnames = _.unique entries.map (entry) ->
    extname = path.extname entry
  entries.forEach (entry) ->
    scanner.scan entry, files, registry, options
  writer.write registry, options
