fs = require 'fs'
path = require 'path'
FirstLine = require './firstline'
less = require 'less'
lessPlugins = require './less-plugins'
outputWriter = require './output-writer'

module.exports =
    render: (filepath) ->
        @getOptions filepath, @renderLess

    renderLess: (options) =>
        return if not options.out

        lessOptions =
            paths: [path.dirname options.file]
            filename: options.file

        if options.compress? and not options.sourceMap? and not options.cleancss?
            lessOptions.compress = true
        else if options.sourceMap? and not options.cleancss?
            lessOptions.sourceMap = if typeof options.sourceMap == 'object' then options.sourceMap else {}

        lessPlugins options, lessOptions

        fs.readFile options.file, (err, contents) =>
            if err
                console.log err
                return

            less.render contents.toString(), options
                .then (output) ->
                    outputWriter.write output, options
                , (err) ->
                    atom.notifications.addError err.message,
                        detail: "#{err.filename}:#{err.line}"
                        dismissable: true

    getOptions: (filepath, callback) ->
        fl = new FirstLine
        fl.read filepath, (err, line) =>
            if err
                atom.notifications.addError err,
                    dismissable: true
                return

            options = @parseFirstLine filepath, line

            if options.main
                @getOptions path.resolve(path.dirname(filepath), options.main), callback
            else
                callback options

    parseFirstLine: (filepath, line) ->
        match = /^\s*\/\/\s*(.*)/.exec(line)
        if !match
            options = {}
        else
            try
                options = JSON.parse '{' + match[1] + '}'
            catch
                atom.notifications.addError 'Cat\'t find LESS options in comment',
                    detail: 'The LESS options must be a valid JSON comment in the first line of the LESS file',
                    dismissable: true
                options = {}

        options.file = filepath
        options
