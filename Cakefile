fs = require 'fs'

{print} = require 'sys'
{spawn} = require 'child_process'
dst = 'extension/build/'
src = 'src/'
task 'watch', 'Build extension code into build/', ->
  coffee = spawn "coffee", ["-w", "-c","-o", dst, src ]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
      print data.toString()

build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', dst, src]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build lib/ from src/', ->
  build()
