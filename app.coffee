express = require 'express'
info = require './package'
http = require 'http'

done = null

app = express()

app.use express.logger()

app.get '/', (req, res)-> res.send version:info.version

port = process.env.PORT || 3000

server = http.createServer app

server.listen port, ->
  console.log "Listening on #{port}"
  done()

module.exports = (ready) -> done = ready
