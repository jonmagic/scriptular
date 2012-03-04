describe 'Results', ->
  beforeEach ->
    @app = new App

  # setup test subjects
  subjects = [
    {'regex': 'a', 'test_strings': ['a'], 'output': '<span>a</span>'}
    {'regex': 'a(.*)c', 'test_strings': ['abc'], 'output': '<span>abc</span>', 'matches': ['b']}
    {'regex': 'a(.*)c', 'test_strings': ['abcdd'], 'output': '<span>abc</span>dd', 'matches': ['b']}
    {'regex': 'f(oo)', 'test_strings': ['foodbar'], 'output': '<span>foo</span>dbar', 'matches': ['oo']}
  ]

  # look thru subjects
  for subject, i in subjects
    do (subject) ->
      it "subject #{i} returns correct output", ->
        @app.expression.value = @app.expression.buildRegex(subject['regex'])
        @app.test_strings.values = subject['test_strings']

        spyOn @app.results, 'drawResults'
        spyOn @app.results, 'drawGroup' if subject['matches']
        @app.results.compile()
        expect(@app.results.drawResults).toHaveBeenCalledWith(subject['output'])

        return unless subject['matches']
        for match in subject['matches']
          expect(@app.results.drawGroup).toHaveBeenCalledWith(1, match)