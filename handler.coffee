fs = require 'fs'
haml = require 'hamljs'
aws = require './aws'
socket = require 'socket.io-client'
haml = require 'hamljs'
io = socket 'http://localhost:8888'

trigger = (res, query) ->
  res.end()
  tsvParse query.message, (QueryData) ->
    campaign_token = QueryData.campaign_token
    publisher_token = QueryData.publisher_token
    id = 'imp-'+campaign_token+'-'+publisher_token
    main = (err, result) ->
      if err
        console.log err
      else
        data =
          campaign_token: campaign_token
          publisher_token: publisher_token
          id: id
          value: result
        io.emit 'pull', data
        res.end 'success'
    aws.getMonthValue(id, main)

tsvParse = (data, callback) ->
  array = data.split('\t')
  result = []
  for item in array
    key = item.split(':', 1)[0]
    val = item.slice(key.length+1, item.length)
    result[key] = val
  callback(result)

exports.trigger = trigger
