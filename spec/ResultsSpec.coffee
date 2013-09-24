describe 'Results', ->
  beforeEach ->
    @app = new App
    $('ul#results').remove()
    $('body').append('<ul id="results"></ul>')
    $('ul#groups').remove()
    $('body').append('<ul id="groups"><li id="match_1"><ol></ol></li></ul>')

  subjects = [
    {'regex': 'a', 'test_strings': [{'string': 'a'}], 'output': '<span>a</span>'}
    {'regex': '(issues)?', 'test_strings': [{'string': 'issues'}], 'output': '<span>issues</span>'}
    {'regex': 'a$', 'test_strings': [{'string': 'asdfja'}], 'output': 'asdfj<span>a</span>'}
    {'regex': '"$', 'test_strings': [{'string': '"hello"'}], 'output': '"hello<span>"</span>'}
    {'regex': 'a(.*)c', 'test_strings': [{'string': 'abcdd', 'matches': ['b']}], 'output': '<span>abc</span>dd'}
    {'regex': 'f(oo)', 'test_strings': [{'string': 'foodbar', 'matches': ['oo']}], 'output': '<span>foo</span>dbar'}
    {
      'regex': 'color-stop\\((.+?)\\)'
      'option':'g'
      'test_strings': [{'string': '-webkit-gradient(linear, right top, left top, color-stop(0, #FF7417), color-stop(1, #82A8FF))'}]
      'output': '-webkit-gradient(linear, right top, left top, <span>color-stop(0, #FF7417)</span>, <span>color-stop(1, #82A8FF)</span>)'
    }
    {
      'regex': '^(https?)'
      'test_strings': [{'string': 'https://github.com', 'matches': ['https']}]
      'output': '<span>https</span>://github.com'
    }
    {
      'regex': '^(https?)://((?:[A-Z0-9]*\\.?)*)((?:\\/?[A-Z0-9])*)'
      'option': 'i'
      'test_strings': [
        {'string': 'https://github.com/jonmagic/scriptular', 'matches': ['https', 'github.com', '/jonmagic/scriptular']}
        {'string': 'http://scriptular.com', 'matches': ['http', 'scriptular.com']}
        {'string': 'http://www.google.com'}
        {'string': 'http://www.guardian.co.uk'}
      ]
      'output': '<span>https://github.com/jonmagic/scriptular</span>'
    }
    {'regex': 'mono', 'option': 'g', 'test_strings': [{'string': 'monolimamonolima'}], 'output': '<span>mono</span>lima<span>mono</span>lima'}
    {'regex': '(<.{1,2}>)', 'option': '', 'test_strings': [{'string': '<li>foo</li>'}], 'output': '<span>&lt;li&gt;</span>foo&lt;/li&gt;'}
    {'regex': '(<\/?(LI)>)', 'option': 'gi', 'test_strings': [{'string': '<li>foo</li>'}], 'output': '<span>&lt;li&gt;</span>foo<span>&lt;/li&gt;</span>'}
  ]

  for subject, i in subjects
    do (subject) ->
      it "subject #{i} returns correct output", ->
        @app.expression.value = @app.expression.buildRegex(subject['regex'], subject['option'])
        @app.test_strings.values = (item['string'] for item in subject['test_strings'])

        @app.results.compile()
        expect($('ul#results li').html()).toEqual(subject['output'])

  for subject in subjects
    do (subject) ->
      it "subject #{subject['regex']} returns correct groups", ->
        for test in subject['test_strings']
          return true unless test['matches']

          @app.expression.value = @app.expression.buildRegex(subject['regex'], subject['option'])
          @app.test_strings.values = [test['string']]

          @app.results.compile()

          expect($('ul#groups ol li').length).toBe(test['matches'].length)

          for match, i in test['matches']
            expect($($('ul#groups ol li')[i]).text()).toEqual(match);
