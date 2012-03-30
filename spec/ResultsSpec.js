(function() {
  describe('Results', function() {
    var i, subject, subjects, _fn, _i, _len, _len2, _results;
    beforeEach(function() {
      this.app = new App;
      $('ul#results').remove();
      $('body').append('<ul id="results"></ul>');
      $('ul#groups').remove();
      return $('body').append('<ul id="groups"><li id="match_1"><ol></ol></li></ul>');
    });
    subjects = [
      {
        'regex': 'a',
        'test_strings': [
          {
            'string': 'a'
          }
        ],
        'output': '<span>a</span>'
      }, {
        'regex': 'a$',
        'test_strings': [
          {
            'string': 'asdfja'
          }
        ],
        'output': 'asdfj<span>a</span>'
      }, {
        'regex': '"$',
        'test_strings': [
          {
            'string': '"hello"'
          }
        ],
        'output': '"hello<span>"</span>'
      }, {
        'regex': 'a(.*)c',
        'test_strings': [
          {
            'string': 'abcdd',
            'matches': ['b']
          }
        ],
        'output': '<span>abc</span>dd'
      }, {
        'regex': 'f(oo)',
        'test_strings': [
          {
            'string': 'foodbar',
            'matches': ['oo']
          }
        ],
        'output': '<span>foo</span>dbar'
      }, {
        'regex': '^(https?)',
        'test_strings': [
          {
            'string': 'https://github.com',
            'matches': ['https']
          }
        ],
        'output': '<span>https</span>://github.com'
      }, {
        'regex': '^(https?)://((?:[A-Z0-9]*\\.?)*)((?:\\/?[A-Z0-9])*)',
        'option': 'i',
        'test_strings': [
          {
            'string': 'https://github.com/jonmagic/scriptular',
            'matches': ['https', 'github.com', '/jonmagic/scriptular']
          }, {
            'string': 'http://scriptular.com',
            'matches': ['http', 'scriptular.com']
          }, {
            'string': 'http://www.google.com'
          }, {
            'string': 'http://www.guardian.co.uk'
          }
        ],
        'output': '<span>https://github.com/jonmagic/scriptular</span>'
      }, {
        'regex': 'mono',
        'option': 'g',
        'test_strings': [
          {
            'string': 'monolimamonolima'
          }
        ],
        'output': '<span>mono</span>lima<span>mono</span>lima'
      }
    ];
    _fn = function(subject) {
      return it("subject " + i + " returns correct output", function() {
        var item;
        this.app.expression.value = this.app.expression.buildRegex(subject['regex'], subject['option']);
        this.app.test_strings.values = (function() {
          var _i, _len2, _ref, _results;
          _ref = subject['test_strings'];
          _results = [];
          for (_i = 0, _len2 = _ref.length; _i < _len2; _i++) {
            item = _ref[_i];
            _results.push(item['string']);
          }
          return _results;
        })();
        this.app.results.compile();
        return expect($('ul#results li').html()).toEqual(subject['output']);
      });
    };
    for (i = 0, _len = subjects.length; i < _len; i++) {
      subject = subjects[i];
      _fn(subject);
    }
    _results = [];
    for (_i = 0, _len2 = subjects.length; _i < _len2; _i++) {
      subject = subjects[_i];
      _results.push((function(subject) {
        return it("subject " + subject['regex'] + " returns correct groups", function() {
          var i, match, test, _j, _len3, _ref, _results2;
          _ref = subject['test_strings'];
          _results2 = [];
          for (_j = 0, _len3 = _ref.length; _j < _len3; _j++) {
            test = _ref[_j];
            if (!test['matches']) {
              return true;
            }
            this.app.expression.value = this.app.expression.buildRegex(subject['regex'], subject['option']);
            this.app.test_strings.values = [test['string']];
            this.app.results.compile();
            expect($('ul#groups ol li').length).toBe(test['matches'].length);
            _results2.push((function() {
              var _len4, _ref2, _results3;
              _ref2 = test['matches'];
              _results3 = [];
              for (i = 0, _len4 = _ref2.length; i < _len4; i++) {
                match = _ref2[i];
                _results3.push(expect($($('ul#groups ol li')[i]).text()).toEqual(match));
              }
              return _results3;
            })());
          }
          return _results2;
        });
      })(subject));
    }
    return _results;
  });
}).call(this);
