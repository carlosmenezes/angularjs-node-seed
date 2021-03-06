

express = require 'express'
routes = require './lib/routes'
http = require 'http'
path = require 'path'
mongoose = require 'mongoose'
MongoStore = require('connect-mongo')(express)
app = express()

settings =
  db: 'test'
  monkdb: 'localhost/test'
  port: 5000

mongoose.connect "mongodb://localhost/#{settings.db}",
  auto_reconnect: true

app.configure ->
  app.set('port', process.env.PORT || 5000)
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'somereallyreallylongsecretstring'
  app.use express.session(
    secret: 'somereallyreallylongsecretstring'
    cookie:
      maxAge: 900000
    store: (new MongoStore
      db: settings.db
    )
  )
  app.use app.router
  app.use require('less-middleware')({ src: __dirname+ '/public'})
  app.use express.static path.join __dirname, 'public'

app.configure 'development', ->
  app.use express.errorHandler()

routes.init(app)

http.createServer(app).listen(app.get('port'), ->
  console.log "Express Server Listening on Port " + app.get 'port'
)
