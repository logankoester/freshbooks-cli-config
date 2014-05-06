nixt = require 'nixt'
path = require 'path'
configFile = path.join(__dirname, 'config_file')
config = require '../index'

showHelp = (result) ->
  if !(result.stdout.match(/--key/))
    return new Error('--key should be mentioned')
  if !(result.stdout.match(/--value/))
    return new Error('--value should be mentioned')
  if !(result.stdout.match(/--file/))
    return new Error('--file should be mentioned')
  if !(result.stdout.match(/--edit/))
    return new Error('--edit should be mentioned')
  if !(result.stdout.match(/--help/))
    return new Error('--help should be mentioned')

exports.group =
  'Using the default config file': (test) ->
    expectedPath = path.join(process.env['HOME'], '.freshbooks')
    test.expect(1)
    test.equals expectedPath, config.configFile()
    test.done()

  'Using environment variables to specify a config file': (test) ->
    process.env['freshbooks_config'] = configFile
    test.expect(1)
    test.equals configFile, config.configFile()
    test.done()

  'Getting a default value in a script': (test) ->
    process.env['freshbooks_config'] = configFile
    test.expect(1)
    test.equals 'default_value', config.getConf().get('test:get_default_value')
    test.done()

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

  'Getting a nested object value': (test) ->
    test.doesNotThrow ->
      nixt()
        .exec("bin/freshbooks-config -k nest:subnest:item -v nested_item -f #{configFile}")
        .run("bin/freshbooks-config -k nest -f #{configFile}")
        .stdout('{"subnest":{"item":"nested_item"}}')
        .code(0)
        .end(test.done)
