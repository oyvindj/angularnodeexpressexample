http = require "http"
express = require "express"
path = require 'path'
persist = require './server/persist'
authentication = require './server/authentication'
autoservices = require './server/autoservices'
services = require './server/services'

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

authentication.init(app)
autoservices.init(app)
services.init(app)
