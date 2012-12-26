# NewLine Stream
Different solutions to handling and piping delimited strings

```bash
npm install newline-stream
```

Simple example of a json stream parser
```javascript
  var NLStream = require('newline-stream');
  var stream = new NLStream(inputStream);
  stream.on('line', function (line) {
    var obj = JSON.parse(line);  
    console.log(obj);
  });
```

Using "pipe"
```javascript

  var NLStream = require('newline-stream');
  var stream   = new NLStream(request);

  stream.pipe(response, function (line) {
    var out = JSON.parse(line).output;
    return JSON.stringify(out);
  });
```

Enabling pause/drain/resume
```javascript
  var NLStream = require('newline-stream');
  var stream   = new NLStream(request, { pause: true });
  stream.on('line', function (line, onFinish) {
    asyncAction(line, onFinish);
  });
```

## Instantiator
```javascript
  var NLStream = require('newline-stream'); 
  var stream   = new NLStream(inputStream, options);
```

### Options
  * separator (string or regexp) - string or regular expression that represents a new line
  * pause (boolean) - if true, pause is called automatically until onFinish is called
