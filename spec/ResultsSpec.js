(function() {

  describe('Results', function() {
    var i, subject, subjects, test, _fn, _len, _len2, _results;
    beforeEach(function() {
      return this.app = new App;
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
        'regex': 'a(.*)c',
        'test_strings': [
          {
            'string': 'abc',
            'matches': ['b']
          }
        ],
        'output': '<span>abc</span>'
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
        'regex': '^(https?)://((?:[A-Z0-9]*\.?)*)((?:\/?[A-Z0-9])*)',
        'test_strings': [
          {
            'string': 'https://github.com/jonmagic/scriptular',
            'matches': ['https', 'github.com', '/jonmagic/scriptular']
          }, {
            'string': 'http://scriptular.com',
            'matches': ['https', 'github.com', '/jonmagic/scriptular']
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
        spyOn(this.app.results, 'drawResult');
        this.app.results.compile();
        return expect(this.app.results.drawResult).toHaveBeenCalledWith(subject['output']);
      });
    };
    for (i = 0, _len = subjects.length; i < _len; i++) {
      subject = subjects[i];
      _fn(subject);
    }
    _results = [];
    for (i = 0, _len2 = subjects.length; i < _len2; i++) {
      subject = subjects[i];
      _results.push((function() {
        var _i, _len3, _ref, _results2;
        _ref = subject['test_strings'];
        _results2 = [];
        for (_i = 0, _len3 = _ref.length; _i < _len3; _i++) {
          test = _ref[_i];
          _results2.push((function(subject) {
            return it("subject " + i + " returns correct groups", function() {
              var match, _j, _len4, _ref2, _results3;
              if (!test['matches']) return true;
              this.app.expression.value = this.app.expression.buildRegex(subject['regex'], subject['option']);
              this.app.test_strings.values = test['string'];
              spyOn(this.app.results, 'drawGroup');
              this.app.results.compile();
              _ref2 = test['matches'];
              _results3 = [];
              for (_j = 0, _len4 = _ref2.length; _j < _len4; _j++) {
                match = _ref2[_j];
                _results3.push(expect(this.app.results.drawGroup).toHaveBeenCalledWith(1, match));
              }
              return _results3;
            });
          })(subject));
        }
        return _results2;
      })());
    }
    return _results;
  });

}).call(this);
