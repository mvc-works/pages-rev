
path = require 'path'
_ = require 'lodash'

scanner = require './scanner'
dir = require './util/dir'
writer = require './writer'

exports.run = (options) ->
  options.ignoreDirs or= []
  unless _.isArray options.entries
    throw new Error 'options.entries are required to start rev'
  unless _.isString options.base
    throw new Error 'options.base is required to start rev'
  unless _.isString options.dest
    throw new Error 'options.dest is required to start rev'
  unless _.isString options.prefix
    throw new Error 'options.prefix is required to start rev'
  unless options.prefix.match(/\/$/)
    throw new Error 'options.prefix should end with a `/`'
  files = dir.recursiveRead options.base, options
  registry = {}
  entries = options.entries.map (name) ->
    path.join options.base, name
  options.templateExtnames = _.unique entries.map (entry) ->
    extname = path.extname entry
  entries.forEach (entry) ->
    scanner.scan entry, files, registry, options
  writer.write registry, options
