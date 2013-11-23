_ = require 'underscore'

class TimeEntry
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

    @required = ['start', 'end', 'duration', 'message']

  validate: ->
    _.every @required, (property) =>
      typeof @[property] isnt 'undefined'

module.exports = TimeEntry

