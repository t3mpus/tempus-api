TimeEntriesController = require "#{__dirname}/../../controllers/time_entries"
TimeEntry = require "#{__dirname}/../../models/time_entry"

handler = (app) ->

  app.post '/time_entries', (req, res) ->
    te = new TimeEntry req.body
    if te.validate()
      TimeEntriesController.create te, (err, time_entry)->
        if err
          res.send 400, error: 'some error'
        else
          res.send time_entry.publicObject()
    else
      res.send 400, error: 'some error'

  app.get '/time_entries/:id', (req, res) ->
    TimeEntriesController.getOne req.params.id, (err, time_entry)->
      if err
        res.send 404, error: "#{req.params.id} not found"
      else
        res.send time_entry.publicObject()

  app.delete '/time_entries/:id', (req, res) ->
    TimeEntriesController.deleteOne req.params.id, (err)->
      if err
        res.send 404, error: "#{req.params.id} not found"
      else
        res.send 200

module.exports = handler
