
crypto = require 'crypto'

exports.md5 = (data) ->
  crypto.createHash('md5').update('Apple').digest("hex")
