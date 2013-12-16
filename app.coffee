express = require 'express'
info = require './package'
http = require 'http'

users = require './routes/users'
projects = require './routes/projects'
time_entries = require './routes/time_entries'

done = null

app = express()

app.use express.logger() if not process.env.TESTING
app.use express.bodyParser()

app.get '/', (req, res)-> res.send version:info.version

users app
projects app
time_entries app

port = process.env.PORT || 3000

server = http.createServer app

server.listen port, ->
  console.log "Listening on #{port}"
  done() if done?

module.exports = (ready) -> done = ready
