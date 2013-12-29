module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib'
  
  grunt.initConfig
    coffee:
      dist:
        files:
          'public/simple-panorama.js': 'src/coffee/**/*.coffee'
    sass:
      dist:
        files:
          'public/simple-panorama.css': 'src/sass/**/*.sass'
          
    uglify: 
      dist:
        files:
          'public/simple-panorama.min.js': 'public/simple-panorama.js'
    
    cssmin: 
      dist:
        files:
          'public/simple-panorama.min.css': 'public/simple-panorama.css'
          
    copy: 
      dist:
        src: 'public/**'
        dest: 'test/'
          
    connect:
      server:
        options:
          port: 8080,
          base: 'test'
          
    watch:
      scripts:
        files: ['src/**']
        tasks: ['test']

  grunt.registerTask 'build', ['coffee', 'sass', 'uglify', 'cssmin']
  grunt.registerTask 'prepareServer', ['build', 'copy']
  grunt.registerTask 'default', ['prepareServer', 'connect', 'watch']
