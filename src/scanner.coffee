
fs = require 'fs'
path = require 'path'

types = require './types'
hash = require './util/hash'
rename = require './util/rename'

scan = (filepath, base, files, registry) ->
  unless (path.extname filepath) in types.scripts
    content = fs.readFileSync filepath
    md5 = hash.md5 content
    relativePath = path.relative base, filepath
    registry[filepath] =
      content: 'content'
      encoding: 'binary'
      finalPath: rename.addMd5 relativePath, md5
    return registry[filepath]

  state =
    name: 'normal' # quote
    buffer: ''
    newFile: ''

  decideBuffer = (buffer) ->
    if buffer[0] is [0]
      potentialFile = path.join base, buffer
    else
      filedir = path.dirname filepath
      potentialFile = path.join filedir, buffer
    if potentialFile in files
      console.log '--> found file, push stack'
      res = scan potentialFile, base, files, registry
      console.log '<-- pop'
      return res.finalPath
    else
      return buffer


  content = fs.readFileSync filepath, 'utf8'
  content.split('').forEach (char) ->
    # console.log char, state
    switch state.name
      when 'normal'
        state.newFile += char
        switch char
          when '\'' then state.name = 'singleQuote'
          when '"' then state.name = 'doubleQuote'
          when '(' then state.name = 'parenthese'
      when 'singleQuote'
        switch char
          when '\''
            state.name = 'normal'
            state.newFile += decideBuffer state.buffer
            state.buffer = ''
          when '\\'
            state.buffer += char
            state.name = 'escapeSingle'
          else state.buffer += char
      when 'escapeSingle'
        state.buffer += char
        state.name = 'singleQuote'
      when 'doubleQuote'
        switch char
          when '\"'
            state.name = 'normal'
            state.newFile += decideBuffer state.buffer
            state.buffer = ''
          when '\\'
            state.buffer += char
            state.name = 'escapeDouble'
          else state.buffer += char
      when 'escapeDouble'
        state.buffer += char
        state.name = 'doubleQuote'
      when 'regexp'
        state.newFile += char
      when 'escapeRegexp'
        state.newFile += char
      when 'parenthese'
        switch char
          when ')'
            state.newFile += decideBuffer state.buffer
            state.buffer = ''
            state.name = 'normal'
            state.newFile += char
          when '\''
            state.newFile += state.buffer
            state.buffer = ''
            state.newFile += char
            state.name = 'singleQuote'
          when '"'
            state.newFile += state.buffer
            state.buffer = ''
            state.newFile += char
            state.name = 'doubleQuote'
          else state.buffer += char
      else throw new Error "state: #{state.name}"

  unless state.name is 'normal'
    throw new Error "EOF state: #{state.name}"

  relativePath = path.relative base, filepath
  md5 = hash.md5 state.newFile
  registry[filepath] =
    content: 'state.newFile'
    encoding: 'utf8'
    finalPath: rename.addMd5 relativePath, md5

  return registry[filepath]

exports.scan = scan
