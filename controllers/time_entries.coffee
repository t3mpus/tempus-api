crypto = require 'crypto'
_ = require 'underscore'

Singleton = require 'singleton'
Riak = require "#{__dirname}/../db/riak"
TimeEntry = require "#{__dirname}/../models/time_entry"

class TimeEntriesController extends Singleton
  bucket: 'time_entries'
  idGen: ()->
    sha = crypto.createHash 'sha1'
    _.each arguments, (d)->
      sha.update JSON.stringify d
    sha.digest 'hex'

  create: (time_entry, callback)->
    if time_entry.userId and time_entry.projectId
      id = @idGen time_entry

      handler = (err, obj, meta) ->
        if err
          callback err
        else
          te = new TimeEntry obj
          te.id = id
          callback null, te

      console.log id, @bucket
      Riak.getClient().save @bucket, id, time_entry,
        {
          index:
            userId: time_entry.userId
            projectId: time_entry.projectId
        }, handler

module.exports = TimeEntriesController.get()
