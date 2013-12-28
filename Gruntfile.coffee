module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib'
  
  # grunt.loadNpmTasks 'grunt-contrib-coffee'
  # grunt.loadNpmTasks 'grunt-contrib-sass'
  # grunt.loadNpmTasks 'grunt-contrib-uglify'
  # grunt.loadNpmTasks 'grunt-contrib-cssmin'
  # grunt.loadNpmTasks 'grunt-contrib-copy'
  # grunt.loadNpmTasks 'grunt-contrib-connect''
  
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
  grunt.registerTask 'test', ['build', 'copy']
  grunt.registerTask 'default', ['connect', 'watch']
