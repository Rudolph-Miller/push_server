route = (handle, path, res, query, em) ->
  if typeof handle[path] == 'function'
    handle[path](res, query, em)
  else
    'No request handler'

exports.route = route
