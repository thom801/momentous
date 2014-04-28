module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: ['coffee:compile']
      stylus:
        files: 'src/*.styl'
        tasks: ['stylus:compile']

    coffee:
      compile:
        files: 'momentous.js': 'src/momentous.coffee'

    stylus:
       compile:
         files: 'momentous.css': 'src/momentous.styl'
