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
        .run('bin/freshbooks-config')
        .code(0)
        .end(test.done)

  '--help': (test) ->
    test.doesNotThrow ->
      nixt()
        .expect(showHelp)
        .run('bin/freshbooks-config --help')
        .code(0)
        .end(test.done)

  'Setting a value': (test) ->
    test.doesNotThrow ->
      nixt()
        .run("bin/freshbooks-config -k foo -v bar -f #{configFile}")
        .exist(configFile)
        .code(0)
        .match(configFile, /"foo": "bar"/)
        .end(test.done)

  'Getting a value': (test) ->
    test.doesNotThrow ->
      nixt()
        .exec("bin/freshbooks-config -k foo -v baz -f #{configFile}")
        .run("bin/freshbooks-config -k foo -f #{configFile}")
        .stdout('baz')
        .code(0)
        .end(test.done)