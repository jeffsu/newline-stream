export class Reader {
  include $m.EventEmitter;

  function initialize(input, options) {
    options = options || {};

    this.input     = input;
    this.separator = options.separator || "\n";
    this.pause     = options.pause || false;
    this.setup();
  }

  function setup() {
    var buffer = "";

    var input = this.input;
    var sep   = this.separator;

    var pause  = this.pause;
    var behind = 0;

    function drain() {
      if (--behind <= 0) {
        behind = 0;
        input.resume();
      }
    }

    input.on('data', #(chunk) {
      if (pause) input.pause();

      var lines = (buffer + chunk).split(sep);
      buffer  = lines.pop();
      behind += lines.length;

      if (lines.length == 0) {
        if (pause) input.resume();
      } else {
        lines.forEach(#{ self.emit('line', $1, drain) });
      }
    });

    input.on('end', #{
      if (buffer.length > 0) {
        self.emit('line', buffer);
        buffer = '';
      }
      self.emit('end');
    });
  }

  function pause() {
    this.input.pause();
  }

  function resume() {
    this.input.resume();
  }

  function pipe(output, cb) {
    var input = this.input;
    cb = cb || #{ => $1 };

    this.on('line', #{
      if (!output.write(cb($1))) input.pause();
    });

    output.on('drain', #{ input.resume() });
    this.on('end',  #{ output.end() });
  }
}
