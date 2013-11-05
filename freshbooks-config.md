# freshbooks-config 

> Configuration manager for freshbooks-cli

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


