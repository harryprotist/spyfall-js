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
