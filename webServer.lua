local sendHttpResponse = require("sendHttpResponse")

-- Small footprint webserver to serve files from flash
local function webServer(connection, request)
    local match = request:match("GET / ")

    -- Default to index.html if no file specified
    if match then
        match = "index.html"
    else
        match = request:match("/(%w*%.%w*)")
    end

    if match then
        local fileSize = file.list()[match]

        if fileSize == nil or string.sub(match, -4) == ".lua"
        or string.sub(match, -3) == ".lc" or string.sub(match, -4) == ".conf" then
            sendHttpResponse(connection, "File not found")
        else
            connection:send("HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/html; charset=ISO-8859-4\r\nContent-Length: " .. fileSize .. "\r\n\r\n")

            file.open(match, "r")
            local usableMemory = node.heap() / 4
            if usableMemory > 1024 then usableMemory = 1024 end
            local contents = file.read(usableMemory)

            while contents ~= nil do
                connection:send(contents)
                contents = file.read(usableMemory)
            end

            file.close()
            return true
        end
    end

    return false
end

return webServer