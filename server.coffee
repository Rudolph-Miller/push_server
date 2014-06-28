http = require 'http'
socketIO = require 'socket.io'
url = require 'url'
haml = require 'hamljs'
qs =  require 'querystring'
events = require 'events'

port = 8888

start = (route, handle) ->
  em = new events.EventEmitter
  onRequest = (req, res) ->
    res.setHeader 'Access-Control-Allow-Origin', 'http://localhost'
    res.writeHead 200, "Content-Type": "text/html"
    url_parts = url.parse(req.url)
    path = url_parts.pathname
    if req.method == 'POST'
      body = ''
      req.on 'data', (data) -> body += data
      req.on 'end', ->
        query = qs.parse body
        route(handle, path, res, query, em)
    else
      query = url_parts.query
      route(handle, path, res, query)

  server = http.createServer(onRequest)
  io = socketIO.listen server
  io.set 'origins', '*:*'
  io.sockets.on 'connection', (socket) ->
    console.log 'connected by ' + socket.id
    socket.emit 'connected'
    socket.on 'init', (data) ->
      campaign_tokens = data.campaignTokens
      for token in campaign_tokens
        socket.join token
        console.log 'join to ' + token
  em.on 'pull', (message) ->
    emit_id = message.emit_id
    io.to(emit_id).emit 'push', message
    console.log 'pushed to: ' + emit_id
    console.log message
  server.listen port

exports.start = start
