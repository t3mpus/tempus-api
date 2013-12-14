BaseModel = require './base'

class TimeEntry extends BaseModel
  constructor: (props) ->
    super props
    @required = ['start', 'end', 'message']

module.exports = TimeEntry

