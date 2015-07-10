socket = io()

window.onload = () ->
  name = window.prompt("What is your name?", "Guest")
  socket.emit("join", [name])

socket.on("join", (names) ->
  names.forEach((name) ->
    console.log(name + " joined")
    li = document.createElement("LI")
    li.innerHTML = name
    document.getElementById("people").appendChild(li)
  )
)

socket.on("time", (time) ->
  document.getElementById("clock").innerHTML = time
)

socket.on("role", (role) ->
  document.getElementById("role").innerHTML = role
)

socket.on("location", (locations) ->
  locations.forEach((loc) ->
    li = document.createElement("LI")
    li.innerHTML = loc.name
    document.getElementById("locations").appendChild(li)
  )
)

window.start_game = () ->
  console.log("clicked")
  socket.emit("start", {})

window.end_game = () ->
  socket.emit("stop", {})
