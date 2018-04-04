fs = require 'fs'

class FirstLine
    read: (filepath, callback) ->
        @callback = callback

        fs.readFile filepath, (err, fileData) =>
            if err != null
                callback err
            callback null, fileData.toString().match /.*/

module.exports = FirstLine
