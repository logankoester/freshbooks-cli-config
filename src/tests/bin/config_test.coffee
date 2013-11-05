nixt = require 'nixt'
path = require 'path'
configFile = 'tests/config_file'

showHelp = (result) ->
  if !(result.stdout.match(/--key/))
    new Error('--key should be mentioned')
  if !(result.stdout.match(/--value/))
    new Error('--value should be mentioned')
  if !(result.stdout.match(/--file/))
    new Error('--file should be mentioned')
  if !(result.stdout.match(/--edit/))
    new Error('--edit should be mentioned')
  if !(result.stdout.match(/--help/))
    new Error('--help should be mentioned')

exports.group =

  'No options': (test) ->
    test.doesNotThrow ->
      nixt()
        .expect(showHelp)
        .run('bin/config.coffee')
        .code(0)
        .end(test.done)

  '--help': (test) ->
    test.doesNotThrow ->
      nixt()
        .expect(showHelp)
        .run('bin/config.coffee --help')
        .code(0)
        .end(test.done)

  'Setting a value': (test) ->
    test.doesNotThrow ->
      nixt()
        .run("bin/config.coffee -k foo -v bar -f #{configFile}")
        .exist(configFile)
        .code(0)
        .match(configFile, /"foo": "bar"/)
        .end(test.done)

  'Getting a value': (test) ->
    test.doesNotThrow ->
      nixt()
        .exec("bin/config.coffee -k foo -v baz -f #{configFile}")
        .run("bin/config.coffee -k foo -f #{configFile}")
        .stdout('baz')
        .code(0)
        .end(test.done)
