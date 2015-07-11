socket = io()

window.onload = () ->
  name = window.prompt("What is your name?", "Guest")
  socket.emit("join", [name])

socket.on("self_join", (name) ->
  li = document.createElement("LI")
  b = document.createElement("B")
  b.textContent = name
  li.appendChild(b)
  document.getElementById("people").appendChild(li)
)

socket.on("join", (names) ->
  names.forEach((name) ->
    console.log(name + " joined")
    li = document.createElement("LI")
    li.textContent = name
    document.getElementById("people").appendChild(li)
  )
)

socket.on("time", (time) ->
  document.getElementById("clock").textContent = time
)

socket.on("role", (role) ->
  document.getElementById("role").textContent = role
)

socket.on("leave", (names) ->
  names.forEach((name) ->
    for child in document.getElementById("people").children
      if (child.textContent && child.textContent == name)
        document.getElementById("people").removeChild(child)
  )
)

socket.on("location", (locations) ->
  locs = document.getElementById("locations")
  while (locs.firstChild)
    locs.removeChild(locs.firstChild)
  locations.forEach((loc) ->
    li = document.createElement("LI")
    li.textContent = loc.name
    locs.appendChild(li)
  )
)

window.start_game = () ->
  console.log("clicked")
  socket.emit("start", {})

window.end_game = () ->
  socket.emit("stop", {})
