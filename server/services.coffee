authentication = require './authentication'
persist = require './persist'

services = {}

entities = ['Foo', 'Bar']

init = (app) ->
  app.get('/myfoos', authentication.isLoggedIn, (req, res) ->
    persist.getAllDb(req, res, 'Myfoo')
  )

  app.post('/myfoos', (req, res) ->
    name = req.body.name
    data = {name: name}
    persist.insertDb(req, res, 'Myfoo', data)
  )

  app.delete('/myfoos/:id', (req, res) ->
    persist.deleteDb(req, res, 'Myfoo')
  )


services.init = init
module.exports = services