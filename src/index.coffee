fs = require 'fs'
path = require 'path'
nopt = require 'nopt'
nconf = require 'nconf'
exec = require('child_process').exec
editor = require 'editor'

exports.defaults =
  api:
    url: 'https://freshbooks.com/api'
    version: 2.1

exports.configFile = ->
  process.env['freshbooks_config'] || path.join(
    process.env['HOME'], '.freshbooks'
  )

exports.getConf = ->
  nconf
    .file(exports.configFile())
    .env()
    .defaults(exports.DEFAULTS)

exports.command = ->
  displayHelp = ->
    manpage = path.join(__dirname, 'man', 'freshbooks-config.1')
    cmd = "man --local-file #{manpage}"
    exec cmd, (err, stdout, stderr) ->
      process.stdout.write "#{stdout}"
      process.stderr.write "#{stderr}"
      console.error err if err

  parsedOptions = nopt
    key: String
    value: String
    file: path
    edit: Boolean
    help: Boolean
  ,
    k: ['--key']
    v: ['--value']
    f: ['--file']
    e: ['--edit']
    h: ['--help']
  , process.argv, 2

  configFile = parsedOptions.file || path.join(
    process.env['HOME'], '.freshbooks'
  )

  nconf.file file: configFile

  if parsedOptions.help
    displayHelp()

  else if parsedOptions.value
    nconf.set parsedOptions.key, parsedOptions.value
    nconf.save (err) ->
      fs.readFile configFile, (err, data) -> console.error err if err

  else if parsedOptions.key
    value = nconf.get(parsedOptions.key)
    if value instanceof Object
      process.stdout.write "#{JSON.stringify(value)}\n"
    else
      process.stdout.write "#{value}\n"

  else if parsedOptions.edit
    editor configFile

  else
    displayHelp()
