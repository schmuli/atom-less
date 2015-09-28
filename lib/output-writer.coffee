fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
async = require 'async'

class OutputWriter
    write: (output, options) ->
        [cssFile, sourceMapFile] = @getDestination options

        async.series
            css: (callback) =>
                @writeFile cssFile, output.css, callback
            map: (callback) =>
                if output.map?
                    @writeFile sourceMapFile, output.map, callback
                else
                    callback null
            , (err, results) ->
                if err
                    atom.notifications.addError err,
                        dismissiable: true
                else if output.map?
                    atom.notifications.addSuccess "Files created"
                else
                    atom.notifications.addSuccess "File created"

    writeFile: (file, content, callback) ->
        mkdirp path.dirname(file), (err) ->
            if err
                atom.notifications.addError err,
                    dismissiable: true
            else
                fs.writeFile file, content, callback

    getDestination: (options) ->
        lessFile = path.basename options.file, '.less'
        lessDir = path.dirname options.file

        if typeof options.out == 'string'
            cssFile = options.out
        else
            cssFile = lessFile + '.css'

        cssFile = path.resolve lessDir, cssFile

        if options.sourceMap?
            sourceMapFile = "#{cssFile}.map"
            sourceMapFile = path.resolve lessDir, sourceMapFile

        return [cssFile, sourceMapFile]

module.exports = new OutputWriter
