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
        'output': '<span>abc</span>'
      }, {
        'regex': 'a(.*)c',
        'test_strings': ['abcdd'],
        'output': '<span>abc</span>dd'
      }
    ];
    _results = [];
    for (i = 0, _len = subjects.length; i < _len; i++) {
      subject = subjects[i];
      _results.push((function(subject) {
        return it("subject " + i + " returns correct output", function() {
          this.app.expression.value = this.app.expression.buildRegex(subject['regex']);
          this.app.test_strings.values = subject['test_strings'];
          spyOn(this.app.results, 'drawResults');
          this.app.results.compile();
          return expect(this.app.results.drawResults).toHaveBeenCalledWith(subject['output']);
        });
      })(subject));
    }
    return _results;
  });

}).call(this);
