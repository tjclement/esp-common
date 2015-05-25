local function sendHttpResponse(connection, data)
    print("sending data of length " .. data:len())
    connection:send("HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/html; charset=ISO-8859-4\r\nContent-Length: " .. data:len() .. "\r\n\r\n" .. data)
end

return sendHttpResponse