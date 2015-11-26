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
            filename: options.file

        if options.compress? and not options.sourceMap? and not options.cleancss?
            lessOptions.compress = true
        else if options.sourceMap? and not options.cleancss?
            lessOptions.sourceMap = if typeof options.sourceMap == 'object' then options.sourceMap else {}

        lessPlugins options, lessOptions

        fs.readFile options.file, (err, contents) =>
            return console.log err if err

            less.render contents.toString(), lessOptions
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
                atom.notifications.addError "#{filepath} does not exist",
                    dismissable: true
                return

            options = @parseFirstLine filepath, line

            if options.main
                if typeof options.main == 'string'
                    @getOptions path.resolve(path.dirname(filepath), options.main), callback
                else
                    for i in [0...options.main.length]
                        @getOptions path.resolve(path.dirname(filepath), options.main[i]), callback

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
