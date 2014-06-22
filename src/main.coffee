'use strict'

http    = require 'http'

_       = require 'underscore'
express = require 'express'
debug   = require 'debug'
cors    = require 'cors'
Q       = require 'q'

{PORT, basicAuth} = require "#{__dirname}/../config"

print = debug 'server'

logger = (err, req, res, next) ->
    print 'Error:'
    print err.stack
    next err

errorHandler = (err, req, res, next) ->
    res.send 500, {error: 'Something blew up'}

exports.server = ->
    app = do express
    server = http.createServer(app)

    # Express 3
    app.use express.basicAuth (basicAuth.username or 'eztabletest'), (basicAuth.password or 'X')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use cors()
    app.use app.routes
    app.use logger
    app.use errorHandler

    # routing
    app.get /.+/, (req, res) ->
        modulePath = "#{__dirname}/../lib#{req.path}"

        f = undefined

        try
            print "Loading module: #{modulePath}"
            f = require modulePath
        catch error
            print "No such module: #{modulePath}"
            return res.send 404, {error: 'no such module'}

        if _.isFunction f
            promise = Q.when f req.query

            promise.fail (err) ->
                print "Err: #{err}"
                res.send 500, {error: 'Something blew up'}
            .done (output) ->
                print "Responding"
                if _.isString output
                    res.set 'Content-Type', 'text/csv'
                    res.send output
                else
                    res.json 200, output
        else
            print "Invalid module: #{modulePath}"
            res.send 500, {error: 'Something blew up'}

    # start server
    port = process.env.PORT or PORT or 8000

    server.listen port
    print "Listening on port #{port}"