(function() {
  var configFile, displayHelp, editor, exec, fs, nconf, nopt, parsedOptions, path, value;

  fs = require('fs');

  path = require('path');

  nopt = require('nopt');

  nconf = require('nconf');

  exec = require('child_process').exec;

  editor = require('editor');

  displayHelp = function() {
    var cmd, manpage;
    manpage = path.join(__dirname, 'man', 'freshbooks-config.1');
    cmd = "man --local-file " + manpage;
    return exec(cmd, function(err, stdout, stderr) {
      process.stdout.write("" + stdout);
      process.stderr.write("" + stderr);
      if (err) {
        return console.error(err);
      }
    });
  };

  parsedOptions = nopt({
    key: String,
    value: String,
    file: path,
    edit: Boolean,
    help: Boolean
  }, {
    k: ['--key'],
    v: ['--value'],
    f: ['--file'],
    e: ['--edit'],
    h: ['--help']
  }, process.argv, 2);

  configFile = parsedOptions.file || path.join(process.env['HOME'], '.freshbooks');

  nconf.file({
    file: configFile
  });

  if (parsedOptions.help) {
    displayHelp();
  } else if (parsedOptions.value) {
    nconf.set(parsedOptions.key, parsedOptions.value);
    nconf.save(function(err) {
      return fs.readFile(configFile, function(err, data) {
        if (err) {
          return console.error(err);
        }
      });
    });
  } else if (parsedOptions.key) {
    value = nconf.get(parsedOptions.key);
    process.stdout.write("" + value + "\n");
  } else if (parsedOptions.edit) {
    editor(configFile);
  } else {
    displayHelp();
  }

}).call(this);
