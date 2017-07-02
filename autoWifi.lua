local autoWifi = {}

local ap_failback_ssid = "ESP" .. string.sub(wifi.ap.getmac(), 6)
local ap_failback_pwd = "MyPassword"

local function setupAsAccessPoint()
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid=ap_failback_ssid, pwd=ap_failback_pwd})
    print("Started in AP wifi mode: " .. ap_failback_ssid .. " " .. wifi.ap.getip())
    return wifi.ap.getip()
end

local function handleConnectAttempt()
    -- Check if we're connected to an access point.
    -- If not, we create our own.
    -- (5 is STATION_GOT_IP)
    if wifi.sta.status() ~= 5 then
        setupAsAccessPoint()
    else
        print("Started in STA wifi mode: " .. wifi.sta.getip())
    end

    ap_failback_ssid = nil
    ap_failback_pwd = nil
end

function autoWifi.setup(sta_ssid, sta_pwd, ip_info, ap_ssid, ap_pwd, timeout)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(sta_ssid, sta_pwd)
    wifi.sta.autoconnect(1)

    if ip_info ~= nil then wifi.sta.setip(ip_info) end

    if ap_ssid ~= nil then ap_failback_ssid = ap_ssid end
    if ap_pwd ~= nil then ap_failback_pwd = ap_pwd end
    if timeout == nil then timeout = 10000 end

    tmr.alarm(6, timeout, 0, handleConnectAttempt)
end

return autoWifi
