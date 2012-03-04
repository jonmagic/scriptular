$ = jQuery

class Expression extends Spine.Controller
  elements:
    'input[name=expression]': 'regexp'
    'input[name=option]': 'option'

  events:
    'keyup input': 'onKeyPress'

  onKeyPress: (event) ->
    try
      @value = @buildRegex @regexp.val(), @option.val()
    catch error
    @.trigger 'update'

  buildRegex: (value, option) ->
    new RegExp(value, option)

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
      @showIntro()
      return true
    else if @expression.regexp.val() == '' || @test_strings.input.val() == ''
      @showError()
      return true

    try
      for value in @test_strings.values
        matches = value.match(@expression.value)
        @matchResults(value, matches)
        @matchGroups(value, matches, count)
        count += 1
      @showOutput()
    catch error
      @showError()

  matchResults: (value, matches) ->
    return unless matches
    string = ''

    for match, i in matches
      break if value == ''
      index   = value.indexOf(match)
      # console.log("#{i}. index: #{index}")
      length  = match.length
      # console.log("#{i}. length: #{length}")
      # console.log("#{i}. string 0: #{string}")
      string += value.slice(0, index)
      # console.log("#{i}. string 1: #{string}")

      # console.log("#{i}. value 0: #{value}")
      value = if index > -1
        string += "<span>#{value.slice(index, index + length)}</span>"
        # console.log("#{i}. string *: #{string}")
        value.slice(index + length)
      else if length > 1
        value.slice(1 + length)
      else
        value.slice(0 + length)
      # console.log("#{i}. value 1: #{value}")

    string += value
    # console.log("#{i}. last string: #{string}")

    @drawResults string

  drawResults: (string) ->
    $('ul#results').append("<li>#{string}</li>")

  matchGroups: (value, matches, count) ->
    return unless matches

    $('ul#groups').append("<li id='match_#{count}'><h3>Match #{count}</h3><ol></ol></li>")

    if @expression.option.val() == 'g'
      for match in matches
        @drawGroup(count, match)
    else
      for match in matches[1..-1]
        @drawGroup(count, match)

  drawGroup: (count, match) ->
    $("ul#groups li#match_#{count} ol").append("<li>#{match}</li>")

  showIntro: ->
    $('#error').hide()
    $('#output').hide()
    $('#intro').show()

  showError: ->
    $('#intro').hide()
    $('#output').hide()
    $('#error').show()

  showOutput: ->
    $('#intro').hide()
    $('#error').hide()
    $('#output').show()

class App
  constructor: ->
    @expression   = new Expression(el: '#expression')
    @test_strings = new TestStrings(el: '#test_strings')
    @results      = new Results(@expression, @test_strings)

window.App = App
window.$ = $