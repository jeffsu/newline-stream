require('mochiscript');
var reporter = require('nodeunit').reporters.default;
reporter.run([ 'tests/stream.ms', 'tests/pipe.ms'  ]);
