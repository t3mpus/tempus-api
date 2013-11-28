started = no

module.exports = (done)->
  if started
    done()
  else
    require(__dirname + '/../app') ->
      started = yes
      done()
