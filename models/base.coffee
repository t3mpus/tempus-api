_ = require 'underscore'

class Base
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

  validate: ->
    _.every @required, (property) =>
      typeof @[property] isnt 'undefined'

  columns: ->
    _.union @required, ['id']

  requiredObject: ->
    r = {}
    _.every @required, (property) =>
      r[property] = @[property]
    r

  publicObject: (addIns = {})->
    r = addIns
    if @public
      _.every @public, (property) =>
        r[property] = @[property]
      r.id = @id if typeof @id isnt 'undefined'
    r

module.exports = Base

