BaseModel = require './base'

class TimeEntry extends BaseModel
  constructor: (props) ->
    super props
    @required = ['start', 'end', 'duration', 'message']

module.exports = TimeEntry

