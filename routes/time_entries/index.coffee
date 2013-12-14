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


module.exports = handler
