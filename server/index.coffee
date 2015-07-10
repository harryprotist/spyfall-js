path = require('path')
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)

server =
  players: []

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
)

http.listen(3000, () ->
  console.log('listening on *:3000')
)
