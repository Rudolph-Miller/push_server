http = require 'http'
socketIO = require 'socket.io'
url = require 'url'
haml = require 'hamljs'
qs =  require 'querystring'
events = require 'events'


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
      campaign_token = data.campaign_token
      publisher_token = data.publisher_token
      socket.join campaign_token
      console.log 'socket joined ' + campaign_token
  em.on 'pull', (message) ->
    campaign_token = message.campaign_token
    io.to(campaign_token).emit 'push', message
    console.log 'pushed to: ' + campaign_token
    console.log message
  server.listen 80

exports.start = start
