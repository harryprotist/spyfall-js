fs = require("fs")

parse_location_file = (filepath) ->
    location_list = []
    location_data = fs.readFileSync(filepath)
    location_obj = JSON.parse(location_data)
    {name: name, roles: location_obj[name]} for name of location_obj
