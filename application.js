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
        this.value = this.buildRegex(this.regexp.val(), this.option.val());
      } catch (error) {

      }
      return this.trigger('update');
    };

    Expression.prototype.buildRegex = function(value, option) {
      return new RegExp(value, option);
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
      } else if (!this.test_strings.values) {
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
        if (value === '') break;
        console.log("This is the match: " + match);
        index = value.indexOf(match);
        length = match.length;
        if (index > -1) {
          string += value.slice(0, index);
          if (index > -1) {
            string += "<span>" + (value.slice(index, index + length)) + "</span>";
          }
          console.log("value before: " + value + " length: " + length + " index: " + index + " string: " + string);
          value = value.slice(length + index);
        }
        console.log("value after: " + value + " string: " + string);
        console.log('');
      }
      string += value;
      return this.drawResult(string);
    };

    Results.prototype.drawResult = function(string) {
      return $('ul#results').append("<li>" + string + "</li>");
    };

    Results.prototype.matchGroups = function(value, matches, count) {
      var match, _i, _j, _len, _len2, _ref;
      if (!matches) return;
      $('ul#groups').append("<li id='match_" + count + "'><h3>Match " + count + "</h3><ol></ol></li>");
      if (this.expression.option.val() === 'g') {
        for (_i = 0, _len = matches.length; _i < _len; _i++) {
          match = matches[_i];
          if (match === '') return;
          this.drawGroup(count, match);
        }
      } else {
        _ref = matches.slice(1);
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          match = _ref[_j];
          if (match === '') return;
          this.drawGroup(count, match);
        }
      }
    };

    Results.prototype.drawGroup = function(count, match) {
      return $("ul#groups li#match_" + count + " ol").append("<li>" + match + "</li>");
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
      this.loadExample = __bind(this.loadExample, this);      this.expression = new Expression({
        el: '#expression'
      });
      this.test_strings = new TestStrings({
        el: '#test_strings'
      });
      this.results = new Results(this.expression, this.test_strings);
      $('#example').bind('click', this.loadExample);
    }

    App.prototype.loadExample = function(event) {
      var option, regex, test_strings;
      event.preventDefault();
      regex = "^(https?)://((?:[A-Z0-9]*\\\.?)*)((?:\\\/?[A-Z0-9])*)";
      option = 'i';
      test_strings = ['https://github.com/jonmagic/scriptular', 'http://scriptular.com', 'http://www.google.com', 'http://www.guardian.co.uk'];
      $('input[name=expression]').val(regex);
      $('input[name=option]').val(option);
      $('textarea').val(test_strings.join('\n'));
      this.expression.onKeyPress();
      this.test_strings.onKeyPress();
      return this.results.compile;
    };

    return App;

  })();

  window.App = App;

  window.$ = $;

}).call(this);
