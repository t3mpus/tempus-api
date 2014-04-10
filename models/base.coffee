_ = require 'underscore'

class Base
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

  validate: ->

    validProperty = (property)=>
      valid = false
      valid = typeof @[property] isnt 'undefined'
      if @validator and @validator[property]
        valid = @validator[property]()
      valid

    req = _.every @required, validProperty

    optionals = yes

    if @atLeastOne
      optionals = _.some @atLeastOne, (o)=>
        if _.isArray o
          return _.every o, validProperty
        else
          return validProperty o

    req and optionals

  optional: ->
    r = []
    if @atLeastOne?
      r = _.flatten @atLeastOne
    r

  columns: ->
    _.union @required, @optional(), ['id']

  requiredObject: ->
    r = {}
    _.every @required, (property) =>
      r[property] = @[property]

    _.each @optional(), (p)=>
      if @[p]
        r[p] = @[p]
    r

  publicObject: (addIns = {})->
    r = addIns
    if @public
      _.every @public, (property) =>
        r[property] = @[property]
    else
      _.every @required, (property) =>
        r[property] = @[property]

      _.each @optional(), (p)=>
        if @[p]
          r[p] = @[p]

    r.id = @id if typeof @id isnt 'undefined'
    r

module.exports = Base

