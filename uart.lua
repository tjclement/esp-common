function setupUart(baudRate)
    if baudRate == nil then baudRate = 9600 end
    uart.setup(0, baudRate, 8, 0, 1, 0)
end
