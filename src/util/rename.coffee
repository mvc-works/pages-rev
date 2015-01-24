
path = require 'path'

exports.addMd5 = (filepath, md5) ->
  extname = path.extname filepath
  filepath.replace extname, ".#{md5[..6]}#{extname}"
