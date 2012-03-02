$ = jQuery

class Expression extends Spine.Controller
  elements:
    'input[name=expression]': 'regexp'
    'input[name=option]': 'option'

  events:
    'keyup input': 'onKeyPress'

  onKeyPress: (event) ->
    @value = new RegExp(@regexp.val(), @option.val())
    @.trigger 'update'

class TestStrings extends Spine.Controller
  elements:
    'textarea': 'input'

  events:
    'keyup textarea': 'onKeyPress'

  onKeyPress: (event) ->
    @getValues(@input.val())
    @.trigger 'update'

  getValues: (val) ->
    @values = val.split('\n')

class Results
  constructor: (@expression, @test_strings) ->
    @expression.bind 'update', @compile
    @test_strings.bind 'update', @compile

  compile: =>
    $('#output').show()
    $('ul#results').empty()
    $('ul#groups').empty()
    count = 1

    for value in @test_strings.values
      @matchResults(value)
      @matchGroups(value, count)
      count += 1

  matchResults: (value) ->
    first  = value.match(@expression.value)[0]
    second = value.split(value.match(@expression.value)[0])
    $('ul#results').append("<li><span>#{first}</span>#{second[1..-1]}</li>")

  matchGroups: (value, count) ->
    $('ul#groups').append("<li id='match_#{count}'><h3>Match #{count}</h3><ol></ol></li>")

    for match in value.match(@expression.value)[1..-1]
      $("ul#groups li#match_#{count} ol").append("<li>#{match}</li>")

class App
  constructor: ->
    @expression   = new Expression(el: '#expression')
    @test_strings = new TestStrings(el: '#test_strings')
    @results      = new Results(@expression, @test_strings)

$ ->
  new App