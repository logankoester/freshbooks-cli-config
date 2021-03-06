(function() {
  var config, configFile, nixt, path, showHelp;

  nixt = require('nixt');

  path = require('path');

  configFile = path.join(__dirname, 'config_file');

  config = require('../index');

  showHelp = function(result) {
    if (!(result.stdout.match(/--key/))) {
      return new Error('--key should be mentioned');
    }
    if (!(result.stdout.match(/--value/))) {
      return new Error('--value should be mentioned');
    }
    if (!(result.stdout.match(/--file/))) {
      return new Error('--file should be mentioned');
    }
    if (!(result.stdout.match(/--edit/))) {
      return new Error('--edit should be mentioned');
    }
    if (!(result.stdout.match(/--help/))) {
      return new Error('--help should be mentioned');
    }
  };

  exports.group = {
    'Using the default config file': function(test) {
      var expectedPath;
      expectedPath = path.join(process.env['HOME'], '.freshbooks');
      test.expect(1);
      test.equals(expectedPath, config.configFile());
      return test.done();
    },
    'Using environment variables to specify a config file': function(test) {
      process.env['freshbooks_config'] = configFile;
      test.expect(1);
      test.equals(configFile, config.configFile());
      return test.done();
    },
    'Getting a default value in a script': function(test) {
      process.env['freshbooks_config'] = configFile;
      test.expect(1);
      test.equals('default_value', config.getConf().get('test:get_default_value'));
      return test.done();
    },
    'No options': function(test) {
      return test.doesNotThrow(function() {
        return nixt().expect(showHelp).run('bin/freshbooks-config').code(0).end(test.done);
      });
    },
    '--help': function(test) {
      return test.doesNotThrow(function() {
        return nixt().expect(showHelp).run('bin/freshbooks-config --help').code(0).end(test.done);
      });
    },
    'Setting a value': function(test) {
      return test.doesNotThrow(function() {
        return nixt().run("bin/freshbooks-config -k foo -v bar -f " + configFile).exist(configFile).code(0).match(configFile, /"foo": "bar"/).end(test.done);
      });
    },
    'Getting a value': function(test) {
      return test.doesNotThrow(function() {
        return nixt().exec("bin/freshbooks-config -k foo -v baz -f " + configFile).run("bin/freshbooks-config -k foo -f " + configFile).stdout('baz').code(0).end(test.done);
      });
    },
    'Getting a nested object value': function(test) {
      return test.doesNotThrow(function() {
        return nixt().exec("bin/freshbooks-config -k nest:subnest:item -v nested_item -f " + configFile).run("bin/freshbooks-config -k nest -f " + configFile).stdout('{"subnest":{"item":"nested_item"}}').code(0).end(test.done);
      });
    }
  };

}).call(this);
