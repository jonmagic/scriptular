(function() {

  describe('Results', function() {
    var i, subject, subjects, _len, _results;
    beforeEach(function() {
      return this.app = new App;
    });
    subjects = [
      {
        'regex': 'a',
        'test_strings': ['a'],
        'output': '<span>a</span>'
      }, {
        'regex': 'a(.*)c',
        'test_strings': ['abc'],
        'output': '<span>abc</span>',
        'matches': ['b']
      }, {
        'regex': 'a(.*)c',
        'test_strings': ['abcdd'],
        'output': '<span>abc</span>dd',
        'matches': ['b']
      }, {
        'regex': 'f(oo)',
        'test_strings': ['foodbar'],
        'output': '<span>foo</span>dbar',
        'matches': ['oo']
      }
    ];
    _results = [];
    for (i = 0, _len = subjects.length; i < _len; i++) {
      subject = subjects[i];
      _results.push((function(subject) {
        return it("subject " + i + " returns correct output", function() {
          var match, _i, _len2, _ref, _results2;
          this.app.expression.value = this.app.expression.buildRegex(subject['regex']);
          this.app.test_strings.values = subject['test_strings'];
          spyOn(this.app.results, 'drawResults');
          if (subject['matches']) spyOn(this.app.results, 'drawGroup');
          this.app.results.compile();
          expect(this.app.results.drawResults).toHaveBeenCalledWith(subject['output']);
          if (!subject['matches']) return;
          _ref = subject['matches'];
          _results2 = [];
          for (_i = 0, _len2 = _ref.length; _i < _len2; _i++) {
            match = _ref[_i];
            _results2.push(expect(this.app.results.drawGroup).toHaveBeenCalledWith(1, match));
          }
          return _results2;
        });
      })(subject));
    }
    return _results;
  });

}).call(this);
