_ = require 'underscore'
crypto = require 'crypto'

class TimeEntry
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

    @required = ['start', 'end', 'duration', 'message']
    @genearted = ['id']

    @genId() if not @id


  validate: ->
    _.every _.union(@required, @genearted), (property) =>
      typeof @[property] isnt 'undefined'

  genId: ()->
    sha = crypto.createHash 'sha256'
    sha.update _.reduce @required, (a,b)=>
      return a + @[b]

    @id = sha.digest 'hex'


module.exports = TimeEntry

