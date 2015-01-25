
gulp = require 'gulp'

gulp.task 'coffee', ->
  coffee = require 'gulp-coffee'

  gulp
  .src 'src/**/*.coffee', base: 'src/'
  .pipe coffee(bare: true)
  .pipe gulp.dest('lib/')
