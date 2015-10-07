fs = require 'fs'

class FirstLine
    read: (filepath, callback) ->
        @callback = callback
        fs.open filepath, 'r', (err, fd) =>
            if (err)
                callback err
            else
                @stats fd

    stats: (fd) ->
        fs.fstat fd, (err, stats) =>
            @startReading fd, stats.size

    startReading: (fd, size) ->
        @fd = fd

        @buffer = new Buffer size
        @buffer.fill 0
        @offset = 0

        @readFile()

    readFile: ->
        length = Math.min(16, @buffer.length - @offset)
        fs.read @fd, @buffer, @offset, length, null, @onRead

    onRead: (err, bytesRead, buffer) =>
        newline = buffer.indexOf '\n', @offset

        if newline > -1
            fs.close @fd, (err) -> console.log err if err
            line = buffer.toString undefined, 0, newline
            @callback null, line
        else
            @offset += bytesRead
            @readFile()

module.exports = FirstLine
