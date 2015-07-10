var socket = io();
window.onload = function() {
  var name = window.prompt("What is your name?", "Guest"); 
  socket.emit("join", [name]);
}
socket.on("join", function(names) {
  names.forEach(function(name) {
    console.log(name + " joined");
    var li = document.createElement("LI");
    li.innerHTML = name;
    document.getElementById("people").appendChild(li);
  });
});
