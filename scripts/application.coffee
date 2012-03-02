$ = jQuery

class Expression extends Spine.Controller
  elements:
    'input[name=expression]': 'regexp'
    'input[name=option]': 'option'

  events:
    'keyup input': 'onKeyPress'

  onKeyPress: (event) ->
    try
      @value = new RegExp(@regexp.val(), @option.val())
    catch error
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
    $('ul#results').empty()
    $('ul#groups').empty()
    count = 1

    if @expression.regexp.val() == '' && @test_strings.input.val() == ''
      $('#error').hide()
      $('#output').hide()
      $('#intro').show()
    else if @expression.regexp.val() == ''
      $('#intro').hide()
      $('#output').hide()
      $('#error').show()
      return true

    try
      for value in @test_strings.values
        @matchResults(value)
        @matchGroups(value, count)
        count += 1
      $('#intro').hide()
      $('#error').hide()
      $('#output').show()
    catch error
      $('#intro').hide()
      $('#output').hide()
      $('#error').show()

  matchResults: (value) ->
    for match in value.match(@expression.value)
      value = if @expression.option.val() == 'g'
        value.replace(new RegExp(match, 'g'), "<span>#{match}</span>")
      else
        value.replace(new RegExp(match), "<span>#{match}</span>")

    $('ul#results').append("<li>#{value}</li>")

  matchGroups: (value, count) ->
    $('ul#groups').append("<li id='match_#{count}'><h3>Match #{count}</h3><ol></ol></li>")

    for match in value.match(@expression.value)
      $("ul#groups li#match_#{count} ol").append("<li>#{match}</li>")

class App
  constructor: ->
    @expression   = new Expression(el: '#expression')
    @test_strings = new TestStrings(el: '#test_strings')
    @results      = new Results(@expression, @test_strings)

$ ->
  new App