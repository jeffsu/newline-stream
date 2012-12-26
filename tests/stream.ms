var Stream = require('../lib');
var fs = require('fs');
var options = { flags: 'r', encoding: null, fd: null, mode: 0666, bufferSize: 10 };
var file    = __dirname + '/data.txt';

module.exports['test line'] = #(test) {
  var stream = new Stream(fs.createReadStream(file, options));
  var count = 0;
  var l = null;

  stream.on('line', #(line) { l = line; count++; });
  stream.on('end', #{ 
    test.equal(l, 'test');
    test.equal(count, 3);
    test.done() 
  });
};

module.exports['test pause'] = #(test) {
  var s = fs.createReadStream(file, options)
  var pause = s.pause;
  var pauseCount = 0;
  s.pause = #{ pauseCount++; pause.apply(s) };

  var stream = new Stream(s, { pause: true });
  var count = 0;
  var l = null;

  stream.on('line', #(line, onFinish) { 
    l = line; count++; 
    onFinish();
  });

  stream.on('end', #{ 
    test.equal(l, 'test');
    test.equal(count, 3);
    test.ok(pauseCount > 1);
    test.done() 
  });
};
