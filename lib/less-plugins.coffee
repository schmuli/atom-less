module.exports =
    (options, optionsLess) ->
        optionsLess.plugins = []

        if options.autoprefix
            addAutoprefix options.autoprefix, optionsLess
        if options.cleancss
            addCleanCss options.cleancss, optionsLess

        optionsLess

addAutoprefix = (options, optionsLess) ->
    AutoprefixLessPlugin = require 'less-plugin-autoprefix'

    autoprefixOptions = options
    if typeof options == 'string'
        autoprefixOptions =
            browsers: options.split ';'

    optionsLess.plugins.push new AutoprefixLessPlugin autoprefixOptions

addCleanCss = (options, optionsLess) ->
    CleanCssLessPlugin = require 'less-plugin-clean-css'

    cleancssOptions = options
    if typeof options == 'string'
        cleancssOptions =
            compatibility: options

    optionsLess.plugins.push new CleanCssLessPlugin cleancssOptions
