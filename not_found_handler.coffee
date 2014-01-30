handler = (req, res, next) ->
  es = "#{req.path} was not found"
  res.send 404, error: es

module.exports = handler
