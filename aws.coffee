aws = require 'aws-sdk'
aws.config.loadFromPath '.aws_credentials.json'
async = require 'async'
dynamo = new aws.DynamoDB


getMonthValue = (id, callback) ->
  now = new Date()
  year = now.getFullYear().toString()
  month = now.getMonth() + 1
  if month < 10
    month = '0' + month.toString()
  date = year + month
  getValue(id, date, callback)

getDayValue = (id, callback) ->
  now = new Date()
  year = now.getFullYear().toString()
  month = now.getMonth() + 1
  day = now.getDate()
  if month < 10
    month = '0' + month.toString()
  if day < 10
    day = '0' + day.toString()
  date = year + month + day
  getValue(id, date, callback)

getValue = (id, date, callback) ->
  params =
    TableName: 'sometracking'
    Key: {
      id: {S: id}
      date: {N: date}
    }
  dynamo.getItem params, (err, data) ->
    if err
      e = err
    else
      d = data['Item']['value']['N']
    callback(e, d)

getIdSumValue = (id, callback) ->
  params =
    TableName: 'sometracking'
    AttributesToGet:[
      'id', 'date', 'value'
    ]
    KeyConditions:
      id:
        ComparisonOperator: 'EQ'
        AttributeValueList:[
          S: id
        ]
      date:
        ComparisonOperator: 'LT'
        AttributeValueList:[
          N: '1000000'
        ]
  dynamo.query params, (err, data) ->
    if err
      callback err
    else
      sum = 0
      async.forEach data.Items, (item) ->
        sum += parseInt item.value.N
      result =
        IdSumVal: sum
      callback null, result

getCampaignSumValue = (campaing_token, callback) ->
  params =
    TableName: 'sometracking'
    AttributesToGet:[
      'id', 'date', 'value'
    ]
    ScanFilter:
      ad_id:
        ComparisonOperator: 'EQ'
        AttributeValueList:[
          S: campaing_token
        ]
      date:
        ComparisonOperator: 'LT'
        AttributeValueList:[
          N: '1000000'
        ]
  dynamo.scan params, (err, data) ->
    if err
      callback null
    else
      sum = 0
      async.forEach data.Items, (item) ->
        if impOrNot item.id.S
          sum += parseInt item.value.N
      result =
        AdSumVal: sum
      callback null, result

impOrNot = (id) ->
  id.slice(0, 3) == 'imp'

exports.getDayValue = getDayValue
exports.getMonthValue = getMonthValue
exports.getIdSumValue = getIdSumValue
exports.getCampaignSumValue = getCampaignSumValue
