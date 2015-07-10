index = (ordered_list) ->
    Math.floor(Math.random() * ordered_list.length)

exports.
shuffle = (ordered_list) ->
    still_ordered = ordered_list.slice()
    unordered_list = []
    while still_ordered.length > 0
        unordered_list = unordered_list.concat(still_ordered.splice(index(still_ordered), 1))
    unordered_list

exports.
choice = (ordered_list) ->
    ordered_list[index(ordered_list)]
