fs = require 'fs'
url = require 'url'
haml = require 'hamljs'
routes = require './routes'

onRequest = (req, res) ->
  res.writeHead 200, "Content-Type": "text/html"
  path = url.parse(req.url).pathname
  routes.route(path)
  body = haml.render fs.readFileSync 'body.haml', 'utf-8'
  res.end body

exports.onRequest = onRequest
