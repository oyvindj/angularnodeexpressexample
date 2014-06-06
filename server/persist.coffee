db = require './db'

persist = {}

persist.insertDb = (req, res, collectionName, data) ->
  db.connect((exampleDb) ->
    db.insert(exampleDb, collectionName, data, req, (item) ->
      res.statusCode = 201
      res.send item
    )
  )


persist.deleteDb = (req, res, collectionName) ->
  id = req.params.id
  db.connect((exampleDb) ->
    db.delete(exampleDb, collectionName, id, (collection) ->
      res.json(true)
    )
  )

persist.getAllDb = (req, res, collectionName) ->
  db.connect((exampleDb) ->
    db.getAll(exampleDb, collectionName, (data) ->
      items = []
      for item in data
        items.push item
      res.statusCode = 302
      res.send items
    )
  )

persist.findByIdDb = (req, res, collectionName) ->
  id = req.params.id
  db.connect((exampleDb) ->
    db.findById(exampleDb, collectionName, id, (item) ->
      console.log 'persist findByIdDb returning ' + collectionName + ' with id ' + id + ': ' + item
      res.statusCode = 302
      res.send item
    )
  )

persist.findByFieldDb = (req, res, collectionName, fieldName, value) ->
  id = req.params.id
  db.connect((exampleDb) ->
    db.findByField(exampleDb, collectionName, fieldName, value, (item) ->
      console.log 'persist findByIdDb returning ' + collectionName + ' with id ' + id + ': ' + item
      res.statusCode = 302
      res.send item
    )
  )

module.exports = persist