var Stream = require('../lib');
var fs     = require('fs');

var options = { flags: 'r', encoding: null, fd: null, mode: 0666, bufferSize: 10 };
var file    = __dirname + '/data.txt';


module.exports['test pipe'] = #(test) {
  var output = 0;
  var ended  = 0;
  var drainCB = null;

  var out = {
    write: #{ output++; drainCB(); return true },
    end:   #{ ended++ },
    on:    #{ drainCB = $2 }
  };

  var stream = new Stream(fs.createReadStream(file, options));
  stream.pipe(out);
  stream.on('end', #{
    test.ok(drainCB);
    test.equal(output, 3);
    test.equal(ended, 1);
    test.done();
  });
};
