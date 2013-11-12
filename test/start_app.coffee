started = no

module.exports = (done)->
  if started
    done()
  else
    require('../app') ->
      started = yes
      done()
