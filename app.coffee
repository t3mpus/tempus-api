express = require 'express'
passport = require 'passport'
_ = require 'underscore'
authentication = require './authentication'
info = require './package'
http = require 'http'

require 'express-namespace'

users = require './routes/users'
projects = require './routes/projects'
time_entries = require './routes/time_entries'
not_found_handler = require './not_found_handler'

done = null

#setup authentication
auth_strategy_name = authentication passport

app = express()

app.use express.logger() if not process.env.TESTING
app.use express.bodyParser()
#app.use '/api', passport.authenticate(auth_strategy_name, session: no)

app.get '/', (req, res)-> res.send version:info.version

_.each [users, projects, time_entries], (s) ->
  app.namespace '/api', ->
    s app

app.use app.router
app.use not_found_handler

port = process.env.PORT || 3000

server = http.createServer app

server.listen port, ->
  console.log "Listening on #{port}"
  done() if done?

module.exports = (ready) -> done = ready
