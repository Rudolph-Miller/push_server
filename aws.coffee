aws = require 'aws-sdk'
aws.config.loadFromPath '/Users/tomoya/.aws_credentials.json'
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

exports.getMonthValue = getMonthValue
exports.getDayValue = getDayValue
