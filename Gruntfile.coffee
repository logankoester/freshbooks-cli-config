#
# * freshbooks-cli-config
# * https://github.com/logankoester/freshbooks-cli-config
# *
# * Copyright (c) 2013 Logan Koester
# * Licensed under the MIT license.
#

path = require 'path'

module.exports = (grunt) ->
  #
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    # Coffeescript
    coffee:
      src:
        expand: true
        cwd: 'src/'
        src: '**/*.coffee'
        dest: '.'
        ext: '.js'

    clean:
      lib: ['lib/', 'tests/', 'man/']

    watch:
      all:
        files: [
          'src/**/*.coffee',
          'bin/**/*.coffee',
          'Gruntfile.coffee',
          'readme/**/*.md'
        ]
        tasks: ['default']

    nodeunit:
      all: ['tests/**/*_test.js']

    readme_generator:
      help:
        options:
          output: 'freshbooks-cli-config.md'
          table_of_contents: false
          generate_footer: false
          has_travis: false
        order:
          'usage.md': 'Usage'
          'examples.md': 'Examples'
      readme:
        options:
          github_username: 'logankoester'
          generate_footer: false
        order:
          'overview.md': 'Overview'
          'usage.md': 'Usage'
          'examples.md': 'Examples'
          'contributing.md': 'Contributing'
          'license.md': 'License'

    bump:
      options:
        commit: true
        commitMessage: 'Release v%VERSION%'
        commitFiles: ['package.json']
        createTag: true
        tagName: 'v%VERSION%'
        tagMessage: 'Version %VERSION%'
        push: false

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-readme-generator'
  grunt.loadNpmTasks 'grunt-bump'

  grunt.registerTask 'marked-man', ->
    done = @async()
    grunt.util.spawn
      cmd: './marked-man'
      args: [path.join(__dirname, 'freshbooks-cli-config.md')]
      opts:
        cwd: path.join(__dirname, 'node_modules', 'marked-man', 'bin')
    , (error, result, code) ->
      throw error if error
      out = path.join __dirname, 'man', 'freshbooks-cli-config.1'
      grunt.file.write out, result.stdout
      done()

  grunt.registerTask 'build', ['clean', 'coffee', 'readme_generator', 'marked-man']
  grunt.registerTask 'test', ['nodeunit']
  grunt.registerTask 'default', ['build', 'test']
