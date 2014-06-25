route = (handle, path, res, query) ->
  if typeof handle[path] == 'function'
    handle[path](res, query)
  else
    'No request handler'

exports.route = route
