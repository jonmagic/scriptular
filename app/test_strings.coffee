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

module.exports = TestStrings