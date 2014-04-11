http = require "http"
express = require "express"
path = require 'path'
persist = require './server/persist'
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
app.use(app.router)

module.exports = server

getUser = (req) ->
    return req.user

app.post('/login', authentication.login(), (req, res) -> res.redirect('/'))

app.get('/logout', (req, res) ->
  authentication.logout(req, res)
)

app.get('/user', (req, res) ->
  res.send getUser(req)
)

app.get('/users', (req, res) ->
  persist.getAllDb(req, res, 'User')
)

app.post('/users', (req, res) ->
  data = {username: req.body.username, password: req.body.password, email: req.body.email}
  persist.insertDb(req, res, 'User', data)
)

app.delete('/users/:id', (req, res) ->
  persist.deleteDb(req, res, 'User')
)

app.get('/users/:id', (req, res) ->
  persist.findByIdDb(req, res, 'User')
)

app.get('/foos', authentication.isLoggedIn, (req, res) ->
  persist.getAllDb(req, res, 'Foo')
)

app.post('/foos', (req, res) ->
    name = req.body.name
    data = {name: name}
    persist.insertDb(req, res, 'Foo', data)
)

app.delete('/foos/:id', (req, res) ->
    persist.deleteDb(req, res, 'Foo')
)

