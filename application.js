(function() {
  var $, App, Expression, Results, TestStrings,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  $ = jQuery;

  Expression = (function(_super) {

    __extends(Expression, _super);

    function Expression() {
      Expression.__super__.constructor.apply(this, arguments);
    }

    Expression.prototype.elements = {
      'input[name=expression]': 'regexp',
      'input[name=option]': 'option'
    };

    Expression.prototype.events = {
      'keyup input': 'onKeyPress'
    };

    Expression.prototype.onKeyPress = function(event) {
      try {
        this.value = new RegExp(this.regexp.val(), this.option.val());
      } catch (error) {

      }
      return this.trigger('update');
    };

    return Expression;

  })(Spine.Controller);

  TestStrings = (function(_super) {

    __extends(TestStrings, _super);

    function TestStrings() {
      TestStrings.__super__.constructor.apply(this, arguments);
    }

    TestStrings.prototype.elements = {
      'textarea': 'input'
    };

    TestStrings.prototype.events = {
      'keyup textarea': 'onKeyPress'
    };

    TestStrings.prototype.onKeyPress = function(event) {
      this.getValues(this.input.val());
      return this.trigger('update');
    };

    TestStrings.prototype.getValues = function(val) {
      return this.values = val.split('\n');
    };

    return TestStrings;

  })(Spine.Controller);

  Results = (function() {

    function Results(expression, test_strings) {
      this.expression = expression;
      this.test_strings = test_strings;
      this.compile = __bind(this.compile, this);
      this.expression.bind('update', this.compile);
      this.test_strings.bind('update', this.compile);
    }

    Results.prototype.compile = function() {
      var count, matches, value, _i, _len, _ref;
      $('ul#results').empty();
      $('ul#groups').empty();
      count = 1;
      if (this.expression.regexp.val() === '' && this.test_strings.input.val() === '') {
        this.showIntro();
        return true;
      } else if (this.expression.regexp.val() === '' || this.test_strings.input.val() === '') {
        this.showError();
        return true;
      }
      try {
        _ref = this.test_strings.values;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          value = _ref[_i];
          matches = value.match(this.expression.value);
          this.matchResults(value, matches);
          this.matchGroups(value, matches, count);
          count += 1;
        }
        return this.showOutput();
      } catch (error) {
        return this.showError();
      }
    };

    Results.prototype.matchResults = function(value, matches) {
      var index, length, match, string, _i, _len;
      if (!matches) return;
      string = '';
      for (_i = 0, _len = matches.length; _i < _len; _i++) {
        match = matches[_i];
        index = value.indexOf(match);
        length = match.length;
        string += value.slice(0, index);
        string += "<span>" + (value.slice(index, index + length)) + "</span>";
        value = value.slice(index + length);
      }
      string += value;
      return $('ul#results').append("<li>" + string + "</li>");
    };

    Results.prototype.matchGroups = function(value, matches, count) {
      var match, _i, _j, _len, _len2, _ref, _results, _results2;
      if (!matches) return;
      $('ul#groups').append("<li id='match_" + count + "'><h3>Match " + count + "</h3><ol></ol></li>");
      if (this.expression.option.val() === 'g') {
        _results = [];
        for (_i = 0, _len = matches.length; _i < _len; _i++) {
          match = matches[_i];
          _results.push($("ul#groups li#match_" + count + " ol").append("<li>" + match + "</li>"));
        }
        return _results;
      } else {
        _ref = matches.slice(1);
        _results2 = [];
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          match = _ref[_j];
          _results2.push($("ul#groups li#match_" + count + " ol").append("<li>" + match + "</li>"));
        }
        return _results2;
      }
    };

    Results.prototype.showIntro = function() {
      $('#error').hide();
      $('#output').hide();
      return $('#intro').show();
    };

    Results.prototype.showError = function() {
      $('#intro').hide();
      $('#output').hide();
      return $('#error').show();
    };

    Results.prototype.showOutput = function() {
      $('#intro').hide();
      $('#error').hide();
      return $('#output').show();
    };

    return Results;

  })();

  App = (function() {

    function App() {
      this.expression = new Expression({
        el: '#expression'
      });
      this.test_strings = new TestStrings({
        el: '#test_strings'
      });
      this.results = new Results(this.expression, this.test_strings);
    }

    return App;

  })();

  $(function() {
    return new App;
  });

}).call(this);
