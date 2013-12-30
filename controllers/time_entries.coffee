crypto = require 'crypto'
_ = require 'underscore'
async = require 'async'

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
            userId: new String time_entry.userId
            projectId: new String time_entry.projectId
        }, handler

  getOne: (key, callback)->
    Riak.getClient().get @bucket, key, (err, te, meta)->
      if err
        return callback err
      else
        callback null, new TimeEntry te

  deleteOne: (key, callback)->
    Riak.getClient().remove @bucket, key, callback

  deleteForProject: (projectId, callback)->
    client = Riak.getClient()
    client.query @bucket, {projectId: new String projectId}, (err, keys)=>
      if err
        callback err
      else if keys.length is 0
        callback()
      else
        async.eachLimit keys, 100, (key,cb)=>
          client.remove @bucket, key, cb
        , callback

  getForProject: (projectId, callback)->
    Riak.getClient().mapreduce.add(
      bucket: @bucket, index: "projectId_bin", key: new String projectId
    ).map('Riak.mapValuesJson').run callback

module.exports = TimeEntriesController.get()
