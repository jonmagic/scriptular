class Expression extends Spine.Controller
  elements:
    'input[name=expression]': 'regexp'
    'input[name=option]': 'option'

  events:
    'keyup input': 'onKeyPress'

  onKeyPress: (event) ->
    @value = new RegExp(@regexp.val(), @option.val())
    @.trigger 'update'

module.exports = Expression