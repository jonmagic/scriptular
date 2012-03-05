describe 'Results', ->
  beforeEach ->
    @app = new App

  # setup test subjects
  subjects = [
    {'regex': 'a', 'test_strings': [{'string': 'a'}], 'output': '<span>a</span>'}
    {'regex': 'a(.*)c', 'test_strings': [{'string': 'abc', 'matches': ['b']}], 'output': '<span>abc</span>'}
    {'regex': 'a(.*)c', 'test_strings': [{'string': 'abcdd', 'matches': ['b']}], 'output': '<span>abc</span>dd'}
    {'regex': 'f(oo)', 'test_strings': [{'string': 'foodbar', 'matches': ['oo']}], 'output': '<span>foo</span>dbar'}
    {
      'regex': '^(https?)'
      'test_strings': [{'string': 'https://github.com', 'matches': ['https']}]
      'output': '<span>https</span>://github.com'
    }
    {
      'regex': '^(https?)://((?:[A-Z0-9]*\.?)*)((?:\/?[A-Z0-9])*)'
      'test_strings': [
        {'string': 'https://github.com/jonmagic/scriptular', 'matches': ['https', 'github.com', '/jonmagic/scriptular']}
        {'string': 'http://scriptular.com', 'matches': ['https', 'github.com', '/jonmagic/scriptular']}
        {'string': 'http://www.google.com'}
        {'string': 'http://www.guardian.co.uk'}
      ]
      'output': '<span>https://github.com/jonmagic/scriptular</span>'
    }
    {'regex': 'mono', 'option': 'g', 'test_strings': [{'string': 'monolimamonolima'}], 'output': '<span>mono</span>lima<span>mono</span>lima'}
  ]

  # look thru subjects
  for subject, i in subjects
    do (subject) ->
      it "subject #{i} returns correct output", ->
        @app.expression.value = @app.expression.buildRegex(subject['regex'], subject['option'])
        @app.test_strings.values = (item['string'] for item in subject['test_strings'])

        spyOn @app.results, 'drawResult'
        @app.results.compile()
        expect(@app.results.drawResult).toHaveBeenCalledWith(subject['output'])

  for subject, i in subjects
    for test in subject['test_strings']
      do (subject) ->
        it "subject #{i} returns correct groups", ->
          return true unless test['matches']

          @app.expression.value = @app.expression.buildRegex(subject['regex'], subject['option'])
          @app.test_strings.values = test['string']

          spyOn @app.results, 'drawGroup'
          @app.results.compile()
          for match in test['matches']
            expect(@app.results.drawGroup).toHaveBeenCalledWith(1, match)

