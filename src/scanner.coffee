
fs = require 'fs'
path = require 'path'

types = require './types'
hash = require './util/hash'
rename = require './util/rename'

scan = (filepath, files, registry, options) ->
  {base, templateExtnames} = options
  unless (path.extname filepath) in types.scripts
    # reuse existing files
    return registry[filepath] if registry[filepath]?

    content = fs.readFileSync filepath
    md5 = hash.md5 content
    relativePath = path.relative base, filepath
    if (path.extname filepath) in templateExtnames
    then finalPath = relativePath
    else finalPath = rename.addMd5 relativePath, md5

    registry[filepath] =
      content: content
      encoding: 'binary'
      finalPath: options.prefix + finalPath
    return registry[filepath]

  state =
    name: 'normal' # quote
    buffer: ''
    newFile: ''

  decideBuffer = (buffer) ->
    if buffer[0] is '/'
      potentialFile = path.join base, buffer
    else
      filedir = path.dirname filepath
      potentialFile = path.join filedir, buffer
    # console.log '---> may be file:', buffer, potentialFile
    if potentialFile in files
      # console.log '    yes'
      res = scan potentialFile, files, registry, options
      return res.finalPath
    else
      # console.log '    no'
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
            state.newFile += '\''
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
            state.newFile += '"'
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
  if (path.extname relativePath) in templateExtnames
  then finalPath = relativePath
  else finalPath = rename.addMd5 relativePath, md5
  registry[filepath] =
    content: state.newFile
    encoding: 'utf8'
    finalPath: options.prefix + finalPath

  return registry[filepath]

exports.scan = scan
