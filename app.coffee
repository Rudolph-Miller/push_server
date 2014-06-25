server = require './server'
request = require './request'
handler = require './handler'
router = require './routes'

handle =
  '/trigger': handler.trigger

server.start(router.route, handle)
