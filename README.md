# atom-less package

An Atom package that auto-compiles LESS files on save, with support for LESS plugins, Clean-CSS and AutoPrefixer.

### Configuration

On the first line of LESS files, add a valid JSON comment, not including the outer brackets ('{' and '}'), with the following properties:

- **"main"**: <code>string</code> -
    The relative or absolute path to the main LESS file to be compiled (ignores all other options)
- **"out"**: <code>boolean|string</code> -
    <code>true</code> to output using the filename, or a string specifying a name to use
- **"compress"**: <code>boolean</code> -
    Use Less.JS built-in compression (not compatible with Clean-CSS or Source Maps)
- **"strictMath"**: <code>boolean</code> -
    Require brackets around math expressions
- **"sourceMap"**: <code>boolean|Object</code> -
    <code>true</code> to turn on source maps, or an object specifying LESS source map properties
- **"cleancss"**: <code>string|object</code> -
    a string specifying the 'compatibility' property,
    or an object specifying the Clean-CSS properties (not compatible with Source Maps)
- **"autoprefixer"**: <code>string|object</code> -
    a <code>;</code> separated string specifying the 'browsers' property,
    or an object specifying the AutoPrefixer properties

Other LESS compiler options might work but are untested at this point.

### Road Map
1. Remove dependency on inline comments, and instead use a .lesscfg project file, allowing easier configuration and automatic support of additional LESS plugins
2. Change callback passing to use Promises
