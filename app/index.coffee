require('jqueryify')
require('spine')

Expression  = require 'expression'
TestStrings = require 'test_strings'
Results     = require 'results'

class App
  constructor: ->
    @expression   = new Expression(el: '#expression')
    @test_strings = new TestStrings(el: '#test_strings')
    @results      = new Results(@expression, @test_strings)

module.exports = App