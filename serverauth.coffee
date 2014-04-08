passport =  require 'passport'
LocalStrategy = require('passport-local').Strategy
flash = require 'connect-flash'

passport.serializeUser((user, done) ->
    done(null, user.id)
)

passport.deserializeUser((id, done) ->
    User.findById(id, (err, user) ->
        done(err, user)
    )
)

serverauth = {}

serverauth.login = (req, res) ->
    console.log 'serverauth authenticating user ' + req.body.username
    passport.use(new LocalStrategy((username, password, callback) ->
        console.log 'in doLogin...'
        User.findOne({ username: username }, (err, user) ->
                if (err)
                    console.log 'error logging in: ' + err
                    return callback(err)
                if (!user) 
                    console.log 'incorrect username...'
                    return callback(null, false, { message: 'Incorrect username.' })
                if (!user.validPassword(password))
                    console.log 'incorrect password...'
                    return callback(null, false, { message: 'Incorrect password.' })
                return callback(null, user)
            )
        )
    )
    callback = (req, res) ->
        console.log 'serverauth authentication finished...'
        res.redirect('/')
    passport.authenticate('local', { successRedirect: '/#/list', failureRedirect: '/login', failureFlash: true }, callback)
    console.log 'serverauth authentication initiated...'
    
module.exports = serverauth 
