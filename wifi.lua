ap_failback_ssid = "ESP" .. string.sub(wifi.ap.getmac(), 6)
ap_failback_pwd = "MyPassword"

function setupAsAccessPoint()
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid=ap_failback_ssid, pwd=ap_failback_pwd})
    return wifi.ap.getip()
end

function handleConnectAttempt()
    -- Check if we're connected to an access point.
    -- If not, we create our own.
    if wifi.sta.getip() == nil then
        print("We're going AP")
        setupAsAccessPoint()
    else
        print("We're STA: " .. wifi.sta.getip())
    end

    ap_failback_ssid = nil
    ap_failback_pwd = nil
end

function setupWifi(sta_ssid, sta_pwd, ap_ssid, ap_pwd, timeout)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(sta_ssid, sta_pwd)

    if ap_ssid ~= nil then ap_failback_ssid = ap_ssid end
    if ap_pwd ~= nil then ap_failback_pwd = ap_pwd end
    if timeout == nil then timeout = 5000 end

    tmr.alarm(6, timeout, 0, handleConnectAttempt)
end
