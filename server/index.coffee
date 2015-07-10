path = require('path')
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)

server = {}
server.players = []
server.locations = parse_location_file(path.join(__dirname, '..', 'locations.json'))
server.game = null
server.clock = 0

app.get('/', (q, r) ->
  r.sendFile(path.join(__dirname, '../client', 'index.html'))
)

io.on('connection', (socket) ->
  console.log("user connected")
  socket.emit("join", server.players)
  socket.on("disconnect", () ->
    console.log("user left")
  )
  socket.on("join", (names) ->
    names.forEach((name) ->
      name = name.replace(/[^A-Za-z0-9]/, "")
      console.log(name + " joined the room")
      server.players.push(name)
      io.emit("join", [name])
    )
  )
  socket.on("start", (time) ->
    server.game = new_game(server.locations, server.players.length)
    server.clock = time * 60
    server.interval = setInterval(() ->
      server.clock--
      if (server.clock < 0)
        clearInterval(server.interval)
        return
      io.emit("time", server.clock)
    , 1000)
  )
)

http.listen(3000, () ->
  console.log('listening on *:3000')
)
