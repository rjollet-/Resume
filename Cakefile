'use strict'

require 'coffee-script/register'

# task 'r', 'run: `Rscript lib/start.R`', ->
#   console.log 'run: `Rscript lib/start.R`'

task 'test', 'run: `mocha` or `npm test`', ->
  console.log 'run `mocha` or `npm test`'

task 'start', 'start the engine', ->
  console.log 'run `DEBUG=server cake start` to see the logs '
  {server} = require "#{__dirname}/src/main"
  do server

# task 'stop', 'stop R via Rserve', ->
#   {shutdown} = require 'rio'
#   f = ->
#     do shutdown
#   do f
#   # just to be sure ;)
#   setTimeout f, 1000