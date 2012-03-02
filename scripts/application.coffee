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
    console.log(value, value.match(@expression.value))
    string = ''

    for match in value.match(@expression.value)
      index = value.indexOf(match)
      length = match.length
      string += value.slice(0, index)
      string += "<span>#{value.slice(index, index + length)}</span>"
      value = value.slice(index + 1)

    $('ul#results').append("<li>#{string}</li>")

  matchGroups: (value, count) ->
    $('ul#groups').append("<li id='match_#{count}'><h3>Match #{count}</h3><ol></ol></li>")

    if @expression.option.val() == 'g'
      for match in value.match(@expression.value)
        $("ul#groups li#match_#{count} ol").append("<li>#{match}</li>")
    else
      for match in value.match(@expression.value)[1..-1]
        $("ul#groups li#match_#{count} ol").append("<li>#{match}</li>")

class App
  constructor: ->
    @expression   = new Expression(el: '#expression')
    @test_strings = new TestStrings(el: '#test_strings')
    @results      = new Results(@expression, @test_strings)

$ ->
  new App