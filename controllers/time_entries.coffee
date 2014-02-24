async = require 'async'
sql = require 'sql'
BaseController = require "#{__dirname}/base"
TimeEntry = require "#{__dirname}/../models/time_entry"

class TimeEntriesController extends BaseController
  time_entry: sql.define
    name: 'time_entries'
    columns: (new TimeEntry).columns()

  create: (time_entry, callback)->
    if time_entry.validate()
      statement = @time_entry.insert time_entry.requiredObject()
                  .returning '*'
      @query statement, (err, rows)->
        if err
          callback err
        else
          callback err, new TimeEntry rows[0]
    else
      callback new Error "Time Entry did not pass validation"

  getOne: (key, callback)->
    statement = @time_entry.select @time_entry.star()
               .from @time_entry
               .where @time_entry.id.equals key
               .limit 1
    @query statement, (err, rows) ->
      if err
        callback err
      else
        callback err, new TimeEntry rows[0]

  deleteOne: (key, callback)->
    statement = @time_entry.delete()
                .from @time_entry
                .where @time_entry.id.equals key
    @query statement, (err)->
      callback err

  deleteForProject: (projectId, callback)->
    statement = @time_entry.delete()
                .where @time_entry.projectId.equals projectId
    @query statement, (err) ->
      callback err


  getForProject: (projectId, callback)->
    statement = @time_entry.select @time_entry.star()
                .from @time_entry
                .where @time_entry.projectId.equals projectId

    @query statement, (err, rows)->
      if err
        callback err
      else
        callback err, rows

module.exports = TimeEntriesController.get()
