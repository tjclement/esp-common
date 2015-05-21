local json = require("cjson")

local settings = {}

function settings.load()
    file.open("settings.conf", "r")
    local contents = file.read()
    file.close()
    return json.decode(contents)
end

function settings.save(object)
    file.remove("settings.conf")
    file.open("settings.conf", "w+")
    local contents = json.encode(object)
    file.write(contents)
    file.close()
end

return settings