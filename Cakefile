{print} = require 'util'
{spawn} = require 'child_process'

build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', './', 'scripts']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

  coffee = spawn 'coffee', ['-c', '-o', 'spec/', 'Spec']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

watch = (callback) ->
  coffee = spawn 'coffee', ['-w', '-c', '-o', './', 'scripts']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

  coffee = spawn 'coffee', ['-w', '-c', '-o', 'spec/', 'Spec']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0


task 'build', 'Build application.js from srcipts/', ->
  build()

task 'watch', 'Continuously compile application.js from scripts/', ->
  watch()
