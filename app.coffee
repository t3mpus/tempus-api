express = require 'express'
info = require './package'
http = require 'http'

users = require './routes/users'
projects = require './routes/projects'

done = null

app = express()

app.use express.logger()
app.use express.bodyParser()

app.get '/', (req, res)-> res.send version:info.version

users app
projects app

port = process.env.PORT || 3000

server = http.createServer app

server.listen port, ->
  console.log "Listening on #{port}"
  done() if done?

module.exports = (ready) -> done = ready
