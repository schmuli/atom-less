{CompositeDisposable} = require 'atom'

renderer = require './less-renderer'

module.exports =
    activate: (state) ->
        @subscriptions = new CompositeDisposable

        @subscriptions.add atom.commands.add 'atom-workspace',
            'core:save': => @render()

    deactivate: ->
        @subscriptions.dispose()

    serialize: ->

    render: ->
        editor = atom.workspace.getActiveTextEditor()
        return if not editor

        grammer = editor.getGrammar()
        return if grammer.name.toLowerCase() != 'less'

        filepath = editor.getPath()
        renderer.render filepath
