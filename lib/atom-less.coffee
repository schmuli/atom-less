renderer = require './less-renderer'

module.exports =
    activate: (state) ->
        atom.workspace.observeTextEditors (editor) =>
            editor.onDidSave (event) =>
                @render event.path

    deactivate: ->
        @subscriptions.dispose()

    serialize: ->

    render: (filepath) ->
        renderer.render filepath
