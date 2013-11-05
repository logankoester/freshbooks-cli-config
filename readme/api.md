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
