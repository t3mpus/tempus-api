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
      time_entry.id = @idGen time_entry

      handler = (err, obj, meta) ->
        if err
          callback err
        else
          callback null, time_entry

      Riak.getClient().save @bucket, time_entry.id, time_entry,
        {
          index:
            userId: time_entry.userId
            projectId: time_entry.projectId
        }, handler

  getOne: (key, callback)->
    Riak.getClient().get @bucket, key, (err, te, meta)->
      if err
        return callback err
      else
        callback null, new TimeEntry te

  deleteOne: (key, callback)->
    Riak.getClient().remove @bucket, key, callback

module.exports = TimeEntriesController.get()
