random = require("random")

class game
    constructor: (@location, @players) ->

    roles: ->
        out = [""]
        roles = random.shuffle(@location.roles)
        (if i < roles.length
            out.push(roles[i])
        else
            out.push(random.choice(roles))
        ) for i in [0...@players-1]
        random.shuffle(out)

    messages: ->
        out = []
        (if role
            out.push("You have been given the role "+role+" at the location "+@location.name+".")
        else
            out.push("You are the spy!")
        ) for role in @roles()
        out

new_game = (locations, players) ->
    new game(random.choice(locations), players)
