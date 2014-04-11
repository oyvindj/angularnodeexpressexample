authentication = require './authentication'
persist = require './persist'

autoservices = {}

entities = ['Foo', 'Bar']

init = (app) ->
  for entity in entities
    do (entity) ->
      console.log 'creating ' + entity + ' services...'
      serviceName = '/'+ entity + 's'
      console.log 'creating ' + serviceName
      app.get(serviceName, authentication.isLoggedIn, (req, res) ->
        console.log 'calling ' + serviceName
        persist.getAllDb(req, res, entity)
      )

      app.post(serviceName, (req, res) ->
        console.log 'calling ' + serviceName
        name = req.body.name
        data = {name: name}
        persist.insertDb(req, res, entity, data)
      )

      serviceName = serviceName + '/:id'
      console.log 'creating ' + serviceName
      app.delete(serviceName, (req, res) ->
        console.log 'calling ' + serviceName
        persist.deleteDb(req, res, entity)
      )

autoservices.init = init
module.exports = autoservices


