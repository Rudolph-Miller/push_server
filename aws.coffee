aws = require 'aws-sdk'
aws.config.loadFromPath '.aws_credentials.json'
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

getSumValue = (id, callback) ->
  id = 'imp-ea703e7aa1efda0064eaa5s7d8ab7e-76d9e697850c9004h'
  params =
    TableName: 'sometracking'
    Select: 'SPECIFIC_ATTRIBUTES'
    AttributesToGet: ['id', 'date', 'value']
    ScanFilter:
      id:
        ComparisonOperator: 'IN'
        AttributeValueList:[
          S: 'imp-ea703e7aa1efda0064eaa5s7d8ab7e-76d9e697850c9004h']
      date:
        ComparisonOperator: 'IN'
        AttributeValueList:[
          N: '201406'
          N: '201407']
      
  dynamo.scan params, (err, data) ->
    if err
      console.log err
    else
      console.log data

exports.getMonthValue = getMonthValue
exports.getDayValue = getDayValue
exports.getSumValue = getSumValue
