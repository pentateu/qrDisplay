module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-steroids"
  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"

  grunt.initConfig
    clean:
      "module-dist":
        "#{__dirname}/bower_components/supersonic-base-module/"
    copy:
      "module-dist":
        expand: true
        cwd: "../dist/"
        src: "**"
        dest: "#{__dirname}/bower_components/supersonic-base-module/"
        filter: "isFile"
    shell:
      "module-build":
        command: "grunt"
        options:
          execOptions:
            cwd: '..'


  grunt.registerTask "default", [
    "shell:module-build"
    "clean:module-dist"
    "copy:module-dist"
    "steroids-make-fresh"
    "steroids-make-module-env"
  ]
