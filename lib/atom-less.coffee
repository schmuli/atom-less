{CompositeDisposable} = require 'atom'

renderer = require './less-renderer'

class AtomLess
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
        return if grammer.name != 'LESS'

        filepath = editor.getPath()
        renderer.render filepath

module.exports = new AtomLess
