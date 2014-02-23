{any} = require 'underscore'

module.exports = (err, req, res, next)->
  message = err.message.toLowerCase()

  check_errors = (k) ->
    message.indexOf(k) isnt -1

  if any ['tokens', 'credentials'], check_errors
    res.send 401
  else
    next err
