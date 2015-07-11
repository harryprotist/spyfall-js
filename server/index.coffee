path = require('path')
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)
game = require('./game.js')
location = require('./location.js')

server = {}
server.players = {}
server.locations = location.parse_location_file(
  path.join(__dirname, '..', 'locations.json')
)
server.game = null
server.clock = 0
server.time_limit = 480
server.state = "IDLE"

app.get('/', (q, r) ->
  r.sendFile(path.join(__dirname, '../client', 'index.html'))
)

io.on('connection', (socket) ->
  console.log("user connected")
  socket.emit("join", Object.keys(server.players))
  player_name = ""
  socket.on("disconnect", () ->
    console.log("user left")
    if (server.players[player_name])
      delete server.players[player_name]
      io.emit("leave", [player_name])
  )
  socket.on("join", (names) ->
    if (names.length == 0 || names[0] == "")
      return
    names.forEach((name) ->
      while (server.players.hasOwnProperty(name))
        name += " Copy"
      player_name = name
      console.log(name + " joined the room")
      server.players[name] = socket
      socket.broadcast.emit("join", [name])
      socket.emit("self_join", name)
      if (server.state == "PLAY")
        socket.emit("role", "Please wait for the next game to start.")
    )
  )
  socket.on("start", () ->

    if (server.state == "PLAY")
      return
    server.state = "PLAY"

    server.game = game.new_game(
      server.locations, Object.keys(server.players).length
    ).messages()
    Object.keys(server.players).forEach((s, i) ->
      server.players[s].emit("role", server.game[i])
    )

    io.emit("location", server.locations)

    server.clock = server.time_limit
    server.interval = setInterval(() ->
      server.clock--
      if (server.clock < 0)
        clearInterval(server.interval)
        return

      mins = Math.floor(server.clock / 60)
      secs = server.clock % 60
      time =
        Math.floor(mins / 10) + "" +
        (mins % 10) + ":" +
        Math.floor(secs / 10) + "" +
        (secs % 10) + ""
      io.emit("time", time)

    , 1000)
  )
  socket.on("stop", () ->
    if (server.state == "IDLE")
      return
    server.state = "IDLE"
    server.game = null
    server.clock = 0
    io.emit("time", "00:00")
    io.emit("role", "Game has not started.")
    io.emit("location", [])
    server.time_limit = 480
  )
)

http.listen(3000, () ->
  console.log('listening on *:3000')
)
