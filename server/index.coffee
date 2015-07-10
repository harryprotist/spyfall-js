path = require('path')
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)

app.get('/', (q, r) ->
  r.sendFile(path.join(__dirname, '../client', 'index.html'))
)

io.on('connection', (socket) ->
  console.log("user connected")
  socket.on("disconnect", () ->
    console.log("user left")
  )
  socket.on("join", (name) ->
    console.log(name + " joined the room")
  )
)

http.listen(3000, () ->
  console.log('listening on *:3000')
)
