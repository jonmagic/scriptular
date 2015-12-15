(->
  self = this
  spawn = undefined
  windowsSpawn = undefined
  spawn = require('child_process').spawn

  windowsSpawn = (executable, args, options) ->
    spawn process.env.comspec or 'cmd.exe', [
      '/c'
      executable
    ].concat(args), options

  if process.platform == 'win32'
    exports.spawn = windowsSpawn
  else
    exports.spawn = spawn
  return
).call this
