    # Set the Freshbooks API base url
    $ freshbooks-config -k api:url -v "https://YOURACCOUNT.freshbooks.com/api"

    # Set the Freshbooks API version
    $ freshbooks-config -k api:version -v 2.1

    # Print the current Freshbooks API version to STDOUT
    $ freshbooks-config -k api:version

    # Edit configuration using a text editor
    $ freshbooks-config --edit
