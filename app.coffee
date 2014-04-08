http = require "http"
express = require "express"
path = require 'path'
db = require './db'
#shared = require './shared'
#cons = require 'consolidate'
#serverauth = require './serverauth'
passport =  require 'passport'
LocalStrategy = require('passport-local').Strategy

app = express()
server = http.createServer(app)
app.use(express.static(path.resolve(__dirname, 'client')))
app.use(express.json())
app.use(express.urlencoded())

# required for passport
app.use(express.cookieParser())
app.use(express.session({ secret: 'ilovescotchscotchyscotchscotch' })) # session secret
app.use(passport.initialize())
app.use(passport.session()) # persistent login sessions
#app.use(flash()) # use connect-flash for flash messages stored in session

#for routing middleware
#app.use(express.bodyParser())
#app.use(express.methodOverride())
app.use(app.router)


users = [
    { id: 1, username: 'bob', password: 'secret', email: 'bob@example.com' }
  , { id: 2, username: 'joe', password: 'birthday', email: 'joe@example.com' }
]

findByUsername = (username, callback) ->
    for user in users
        if (user.username == username)
            return callback(null, user)
    return callback(null, null)

findById = (id, callback) ->
    idx = id - 1
    if(users[idx])
        callback(null, users[idx])
    else
        callback(new Error('User ' + id + ' does not exist'))
    
passport.serializeUser((user, done) ->
    done(null, user.id)
)
passport.deserializeUser((id, done) ->
    findById(id, (err, user) ->
        done(err, user)
    )
)

passport.use(new LocalStrategy((username, password, done) ->
    console.log 'in doLogin...'
    findByUsername(username, (err, user) ->
        if (err) 
            return done(err)
        if (!user) 
            return done(null, false, { message: 'Unknown user ' + username })
        if (user.password != password) 
            return done(null, false, { message: 'Invalid password' })
        return done(null, user)
    )
))

isLoggedIn = (req, res, next) ->
	if (req.isAuthenticated())
		return next();
	res.send('access denied')

module.exports = server

app.post('/login', passport.authenticate('local', {failureRedirect: '/'}), (req, res) -> res.redirect('/'))

app.get('/logout', (req, res) ->
    req.logout()
    res.redirect('/')
)

app.get('/foos', isLoggedIn, (req, res) ->
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


