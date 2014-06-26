fs = require 'fs'
haml = require 'hamljs'
aws = require './aws'
haml = require 'hamljs'

trigger = (res, query, em) ->
  res.end()
  tsvParse query.message, (QueryData) ->
    campaign_token = QueryData.campaign_token
    publisher_token = QueryData.publisher_token
    id = 'imp-'+campaign_token+'-'+publisher_token
    data =
      campaign_token: campaign_token
      publisher_token: publisher_token
      id: id
    main = (err, result) ->
      if err
        console.log err
      else
        em.emit 'pull', result
    aws.getIdSumValue(data, main)
    aws.getCampaignSumValue(data, main)

tsvParse = (data, callback) ->
  array = data.split('\t')
  result = []
  for item in array
    key = item.split(':', 1)[0]
    val = item.slice(key.length+1, item.length)
    result[key] = val
  callback(result)

exports.trigger = trigger
