http = require "http"
express = require "express"
path = require 'path'
db = require './server/db'
authentication = require './server/authentication'

app = express()
server = http.createServer(app)
app.use(express.static(path.resolve(__dirname, 'client')))
app.use(express.json())
app.use(express.urlencoded())

# required for passport
app.use(express.cookieParser())
app.use(express.session({ secret: 'ilovescotchscotchyscotchscotch' }))
app.use(authentication.passport.initialize())
app.use(authentication.passport.session())

#for routing middleware
#app.use(express.bodyParser())
#app.use(express.methodOverride())
app.use(app.router)

module.exports = server

app.post('/login', authentication.login(), (req, res) -> res.redirect('/'))

app.get('/logout', (req, res) ->
  authentication.logout(req, res)
)

app.get('/foos', authentication.isLoggedIn, (req, res) ->
    console.log 'getting foos for user: '
    console.log req.user
    db.connect((exampleDb) ->
        db.getAll(exampleDb, 'Foo', (items) ->
            foos = []
            for item in items
                foos.push item
            res.send foos
        )
    )
)

app.get('/user', (req, res) ->
    res.send req.user
)

app.post('/foos', (req, res) ->
    name = req.body.name
    db.connect((exampleDb) ->
        db.insert(exampleDb, 'Foo', name, (name) -> 
            console.log 'foo inserted: ' + name
            res.status 201
            res.send name
        )
    )
)

app.delete('/foos/:id', (req, res) ->
    id = req.params.id
    console.log 'deleting foo id: ' + id
    db.connect((exampleDb) ->
        db.delete(exampleDb, 'Foo', id, (collection) ->
            console.log 'app deleted Foo with id ' + id
            res.json(true)
            console.log 'response was sent...'
        )
    )
)

app.post('/addresses', (req, res) ->
    name = req.body.name
    db.connect((exampleDb) ->
        db.insert(exampleDb, 'Address', name, (name) -> 
            console.log 'inserted address'
            res.send(name)
        )
    )
)


