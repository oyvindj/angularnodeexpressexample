db = require './db'

persist = {}

persist.insertDb = (req, res, collectionName, data) ->
  db.connect((exampleDb) ->
    db.insert(exampleDb, collectionName, data, req, (item) ->
      res.status 201
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
      res.status = 302
      res.send items
    )
  )

persist.findByIdDb = (req, res, collectionName, id) ->
  id = req.params.id
  db.connect((exampleDb) ->
    db.findById(exampleDb, collectionName, id, (item) ->
      res.status = 302
      res.send item
    )
  )


module.exports = persist