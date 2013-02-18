fs = require 'fs'

module.exports = (grunt)->
    'use strict'

    grunt.initConfig
        pkg: '<json:package.json>'
        simplemocha:
            options:
                reporter: 'dot'
            target: 'test/*.js'
        jshint:
            all: ['src/core.js', 'src/**/*.js']
            options:
                curly   : true
                eqeqeq  : true
                latedef : true
                noarg   : true
                noempty : true
                quotmark: 'double'
                undef   : true
                strict  : true
                trailing: true
                newcap  : false
                browser : true
                node    : true
                predef  : ['timbre']
        uglify:
            all:
                options:
                    sourceMap: 'timbre.js.map'
                files:
                    'timbre.js': ['timbre.dev.js']
        clean: ['timbre.js', 'timbre.js.map', '*.html', 'ja/*.html']

    grunt.loadNpmTasks 'grunt-contrib-jshint'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-simple-mocha'

    grunt.registerTask 'build', ->
        build_timbre = require('./build/timbre-builder')
        opts = build_timbre.build()
        fs.writeFileSync "timbre.dev.js", opts.source, 'utf-8'
        console.log "#{opts.version} - #{(opts.size / 1024).toFixed(2)}KB"

    grunt.registerTask 'doc', ->
        DocFileBuilder = require('./build/html-builder').DocFileBuilder
        DocFileBuilder.build_statics()

    grunt.registerTask 'gh-pages', ['clean', 'uglify', 'doc']

    grunt.registerTask 'default', ['jshint', 'simplemocha']
    grunt.registerTask 'test', ['simplemocha']
    grunt.registerTask 'all', ['default', 'build']
