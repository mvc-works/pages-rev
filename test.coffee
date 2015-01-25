
rev = require './src/index'

rev.run
  base: "#{__dirname}/example/"
  dest: "#{__dirname}/dist/"
  ignoreDirs: ['node_modules']
  entries: ['index.html', 'ejs/home.ejs']
  prefix: '/'