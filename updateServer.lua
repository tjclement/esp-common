local updateServer = {}

local function onReceive(connection, data)
    node.output(function(data)
        connection:send(data) 
    end)
    node.input(data)
end

function updateServer.start()
    srv=net.createServer(net.UDP, 30)
    srv:listen(23)
    srv:on("receive", onReceive)
end

return updateServer
