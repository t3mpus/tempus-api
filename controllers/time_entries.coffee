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

    else
      callback new Error "Time Entry did not pass validation"

  getOne: (key, callback)->

  deleteOne: (key, callback)->

  deleteForProject: (projectId, callback)->

  getForProject: (projectId, callback)->

module.exports = TimeEntriesController.get()
