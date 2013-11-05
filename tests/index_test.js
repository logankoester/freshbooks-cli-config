(function() {
  var configFile, nixt, path, showHelp;

  nixt = require('nixt');

  path = require('path');

  configFile = 'tests/config_file';

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
    }
  };

}).call(this);
