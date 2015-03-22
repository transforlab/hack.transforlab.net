require! <[gulp gulp-util express connect-livereload gulp-livereload path gulp-compass gulp-jade gulp-plumber]>

app = express!

build_path = '_public'

gulp.task 'sass', ->
  gulp.src 'sass/*.sass'
    .pipe gulp-plumber errorHandler: (error) ->
      gulp-util.log gulp-util.colors.red error.message
    .pipe gulp-compass {sass: 'sass', css: "#{build_path}/css", sourcemap: 'ture'}
    .pipe gulp.dest "#{build_path}/css"

gulp.task 'jade', ->
  gulp.src './views/*.jade'
    .pipe gulp-plumber!
    .pipe gulp-jade!
    .pipe gulp.dest "#{build_path}"

gulp.task 'html', ->
  gulp.src './views/backup/*.html'
    .pipe gulp.dest "#{build_path}"

gulp.task 'assets', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest "#{build_path}/assets"

gulp.task 'js', ->
  gulp.src 'js/*.js'
    .pipe gulp.dest "#{build_path}/js"

gulp.task 'gh-pages', ->
  gulp.src 'CNAME'
    .pipe gulp.dest "#{build_path}"

gulp.task 'dokku', ->
  gulp.src 'dotfiles/.*'
    .pipe gulp.dest "#{build_path}"

gulp.task 'server', ->
  app.use connect-livereload!
  app.use express.static path.resolve "#{build_path}"
  app.listen 3000
  gulp-util.log 'listening on port 3000'

gulp.task 'watch', ->
  gulp-livereload.listen silent: true
  gulp.watch 'sass/*.sass', <[sass]> .on \change, gulp-livereload.changed
  gulp.watch './views/*.jade', <[jade]> .on \change, gulp-livereload.changed
  gulp.watch './views/backup/*.html', <[html]> .on \change, gulp-livereload.changed
  gulp.watch 'js/*js', <[js]> .on \change, gulp-livereload.changed

gulp.task 'build', <[jade sass html js assets dokku]>
gulp.task 'dev', <[build server watch]>
gulp.task 'default', <[build]>
