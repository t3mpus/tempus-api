module.exports = (err, req, res, next)->
  if err.message.toLowerCase().indexOf('tokens') isnt -1
    res.send 401
  else
    next err
