started = no

module.exports = (done)->
  if started or process.env.TEMPUS_HOST
    done()
  else
    require(__dirname + '/../app') ->
      started = yes
      done()
