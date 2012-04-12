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

  asUrlPart:() ->
    encodeURIComponent(@regexp.val() + "||||" + @option.val())

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

  asUrlPart:() ->
    encodeURIComponent(JSON.stringify(@values))

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
    else unless @test_strings.values
      return true

    try
      for value in @test_strings.values
        matches = value.match(@expression.value)
        @matchResults(value, matches)
        @matchGroups(value, matches, count)
        count += 1
      @addShareLink(@expression.asUrlPart(), @test_strings.asUrlPart())
      @showOutput()
    catch error
      @showError()

  addShareLink: (expression_url, test_strings_url) ->
    url =  window.location.protocol + "//" + window.location.host
    url += "/#" + expression_url + encodeURIComponent("||||") + test_strings_url
    $("#share_link").attr("href", url)

  matchResults: (value, matches) ->
    return unless matches
    string = ''

    matches = @generateMatches(value,@expression.value);
    for match in matches
      break if value == ''

      # console.log("This is the match: #{match}")

      index =  match.index
      length = match.length
      if index > -1
        string += value.slice(0, index)
        string += "<span>#{value.slice(index, index + length)}</span>" if index > -1

        # console.log("value before: #{value} length: #{length} index: #{index} string: #{string}")
        value = value.slice(length + index)

      # console.log("value after: #{value} string: #{string}")
      # console.log('')

    string += value

    @drawResult string

  generateMatches: (value, regex) ->
    result = []
    while execution = regex.exec(value) 
        index = execution.index
        length = execution[0].length
        result.push({index:index,length:length})
        break if length+index == 0
        value = value.substr(length+index)
        regex.lastIndex = 0
    result

  drawResult: (string) ->
    $('ul#results').append("<li>#{string}</li>")

  matchGroups: (value, matches, count) ->
    return unless matches

    $('ul#groups').append("<li id='match_#{count}'><h3>Match #{count}</h3><ol></ol></li>")

    if @expression.option.val() == 'g'
      for match in matches
        return if match == ''
        @drawGroup(count, match)
    else
      for match in matches[1..-1]
        return if match == ''
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
    $('#example').bind 'click', @loadExample
    @loadFromHash() if window.location.hash != ''

  loadFromHash: () =>
    [regex, option, test_strings_from_url] = decodeURIComponent(window.location.hash.substr(1)).split("||||")
    test_strings_from_url =  JSON.parse(test_strings_from_url)

    @load(regex,option,test_strings_from_url)

  loadExample: (event) =>
    event.preventDefault()

    regex = "^(https?)://((?:[A-Z0-9]*\\\.?)*)((?:\\\/?[A-Z0-9])*)"
    option = 'i'
    test_strings = [
      'https://github.com/jonmagic/scriptular'
      'http://scriptular.com'
      'http://www.google.com'
      'http://www.guardian.co.uk'
    ]

    @load(regex,option,test_strings)

  load: (regex,option,test_strings) =>
    $('input[name=expression]').val(regex)
    $('input[name=option]').val(option)
    $('textarea').val(test_strings.join('\n'))
    @expression.onKeyPress()
    @test_strings.onKeyPress()
    @results.compile


window.App = App
window.$ = $
