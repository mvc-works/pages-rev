
rev = require './src/index'

rev.run
  base: "#{__dirname}/example/"
  ignoreDirs: ['node_modules']
  entries: ['index.html', 'ejs/home.ejs']
  dest: '../dist/'
  prefix: ''