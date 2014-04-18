passport =  require 'passport'
persist = require './persist'
db = require './db'
LocalStrategy = require('passport-local').Strategy

users = [
  { id: 1, username: 'bob', password: 'secret', email: 'bob@example.com' }
  { id: 2, username: 'joe', password: 'birthday', email: 'joe@example.com' }
]

findByUsername = (username, callback) ->
  db.connect((exampledb) ->
    db.findByField(exampledb, 'User', 'username', username, (user) ->
      if (user.username == username)
        return callback(null, user)
      return callback(null, null)
    )
  )

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

login = () ->
  passport.authenticate('local', {failureRedirect: '/'})

logout = (req, res) ->
  req.logout()
  res.redirect('/')

getUser = (req) ->
  return req.user

init = (app) ->
  app.post('/login', login(), (req, res) -> res.redirect('/'))

  app.get('/logout', (req, res) ->
    logout(req, res)
  )

  app.get('/user', (req, res) ->
    res.send getUser(req)
  )

  app.get('/users', (req, res) ->
    persist.getAllDb(req, res, 'User')
  )

  app.post('/users', (req, res) ->
    data = {username: req.body.username, password: req.body.password, email: req.body.email, isAdmin: false}
    persist.insertDb(req, res, 'User', data)
  )

  app.delete('/users/:id', (req, res) ->
    persist.deleteDb(req, res, 'User')
  )

  app.get('/users/:id', (req, res) ->
    persist.findByIdDb(req, res, 'User')
  )


authentication = {}

authentication.init = init
authentication.users = users
authentication.findByUsername = findByUsername
authentication.findById = findById
authentication.login = login
authentication.logout = logout
authentication.isLoggedIn = isLoggedIn
authentication.passport = passport

module.exports = authentication
