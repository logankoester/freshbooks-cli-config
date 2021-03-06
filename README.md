# freshbooks-cli-config 
[![Build Status](https://secure.travis-ci.org/logankoester/freshbooks-cli-config.png?branch=master)](http://travis-ci.org/logankoester/freshbooks-cli-config)

> Configuration manager for freshbooks-cli

## Overview

[freshbooks-cli](https://github.com/logankoester/freshbooks-cli) is a
command-line interface to the [FreshBooks](http://freshbooks.com/) API.

`freshbooks-cli-config` implements the `config` subcommand for
[freshbooks-cli](https://github.com/logankoester/freshbooks-cli).


## Usage

    --key, -k [String] - A configuration key to operate on. If --value is not
                         set, the current value will be written to STDOUT. Keys
                         are namespaced and delimited by ':'.

    --value, -v [String] - Save a new value to the specified key.

    --file, -f [Path] - Explicitely specify the configFile to operate on. If
                        not set, $HOME/.freshbooks will be used.

    --edit, -e - Manually edit configuration with $EDITOR

    --help, -h - Display this message


## Examples

    # Set the Freshbooks API base url
    $ freshbooks-config -k api:url -v "https://YOURACCOUNT.freshbooks.com/api"

    # Set the Freshbooks API version
    $ freshbooks-config -k api:version -v 2.1

    # Print the current Freshbooks API version to STDOUT
    $ freshbooks-config -k api:version

    # Edit configuration using a text editor
    $ freshbooks-config --edit


## API

You can (and should!) use this interface to manage user configuration within
your own **freshbooks-cli** plugins.

```coffee

config = require 'freshbooks-cli-config'

# Reading the global defaults
config.defaults

# Getting the current freshbooks\_config file path
config.configFile()

# Retrieving the nconf object
nconf = config.getConf()

# Retrieving a value
nconf.get 'namespace:key'

```

The [nconf](https://github.com/flatiron/nconf) object returned using
`configFile()` has already loaded the `freshbooks\_config` file,
env overrides, and the global defaults (in that order of precedence).

The default `freshbooks\_config` file is `~/.freshbooks`, which can be
changed by setting the environment variable `freshbooks\_config=PATH`

See [nconf](https://github.com/flatiron/nconf) for details.


## Contributing

The test suite is implemented with
[nodeunit](https://github.com/caolan/nodeunit) and
[nixt](https://github.com/vesln/nixt).

To rebuild & run the tests

    $ git clone https://github.com/logankoester/freshbooks-cli-config.git
    $ cd freshbooks-cli-config
    $ npm install
    $ grunt test

You can use `grunt watch` to automatically rebuild and run the test suite when
files are changed.

Use `npm link` from the project directory to tell `freshbooks-cli` to use
your modified `freshbooks-cli-config` during development.

To contribute back, fork the repo and open a pull request with your changes.


## License

Copyright (c) 2013-2014 Logan Koester
Licensed under the MIT license.


