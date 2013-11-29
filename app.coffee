express = require 'express'
info = require './package'
http = require 'http'

users = require './routes/users'

done = null

app = express()

app.use express.logger()

app.get '/', (req, res)-> res.send version:info.version

users app

port = process.env.PORT || 3000

server = http.createServer app

server.listen port, ->
  console.log "Listening on #{port}"
  done() if done?

module.exports = (ready) -> done = ready
