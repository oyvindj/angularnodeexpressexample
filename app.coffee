http = require "http"
express = require "express"
path = require 'path'
db = require './db'

router = express()
server = http.createServer(router)
router.use(express.static(path.resolve(__dirname, 'client')))
router.use(express.json())
router.use(express.urlencoded())

module.exports = server

router.get('/foos', (req, res) ->
    db.connect((exampleDb) ->
        db.getAll(exampleDb, 'Foo', (items) ->
            #output = ''
            foos = []
            for item in items
                #output = output + ', ' + item.name
                foos.push item
            res.send(foos)
        )
    )
)

router.post('/foos', (req, res) ->
    name = req.body.name
    db.connect((exampleDb) ->
        db.insert(exampleDb, 'Foo', name, (name) -> 
            console.log 'foo inserted: ' + name
            res.status 201
            res.send name
        )
    )
)

router.delete('/foos/:id', (req, res) ->
    id = req.params.id
    console.log 'deleting foo id: ' + id
    db.connect((exampleDb) ->
        db.delete(exampleDb, 'Foo', id, (collection) ->
            console.log 'app deleted Foo with id ' + id
            #res.send(collection)
            res.json(true)
            console.log 'response was sent...'
        )
    )
)

router.post('/addresses', (req, res) ->
    name = req.body.name
    db.connect((exampleDb) ->
        db.insert(exampleDb, 'Address', name, (name) -> 
            console.log 'inserted address'
            res.send(name)
        )
    )
)