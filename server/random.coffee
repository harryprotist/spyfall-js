index = (ordered_list) ->
    Math.floor(Math.random() * ordered_list.length)

exports.
shuffle = (ordered_list) ->
    unordered_list = []
    while ordered_list.length > 0
        unordered_list += ordered_list.splice(index(ordered_list), 1)

exports.
choice = (ordered_list) ->
    ordered_list[index(ordered_list)]
