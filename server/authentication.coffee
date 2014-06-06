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
  db.connect((exampledb) ->
    db.findById(exampledb, 'User', id, (user) ->
      console.log 'auth findById got back: ' + user
      if(user)
        callback(null, user)
      else
        callback(new Error('User ' + id + ' does not exist'))

    )
  )

passport.serializeUser((user, done) ->
  done(null, user._id)
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
      console.log 'login error: ' + err
      return done(err)
    if (!user)
      console.log 'unknown user: ' + username
      return done(null, false, { message: 'Unknown user ' + username })
    if (user.password != password)
      console.log 'invalid password for user: ' + username
      return done(null, false, { message: 'Invalid password' })
    console.log 'use ' + username + ' logged in '
    return done(null, user)
  )
))

isLoggedIn = (req, res, next) ->
  if (req.isAuthenticated())
    return next();
  res.statusCode = 401
  res.send('access denied')

login = (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    if(err)
      res.statusCode = 501
      res.send 'system error during login'
    if(!user)
      res.statusCode = 403
      res.send 'login failed'
    else
      res.statusCode = 200
      req.logIn(user, (err) ->
        if (err)
          return next(err)
      )
      res.send 'login ok'
  )(req, res, next)

logout = (req, res) ->
  req.logout()
  res.redirect('/')

getUser = (req) ->
  return req.user

init = (app) ->
  #app.post('/login', login(), (req, res) -> res.redirect('/'))

  app.post('/login', (req, res, next) -> login(req, res, next))

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
