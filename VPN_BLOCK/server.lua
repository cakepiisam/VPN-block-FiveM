AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("TeamFox: Sinun IP tarkistetaan.", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("TeamFox: Emme havainneet aitoa IP osoitetta.")
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy,hosting", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if (tbl["proxy"] == false and tbl['hosting'] == false) then
                    deferrals.done()
                else
                    deferrals.done("TeamFox: Olemme havainneet VPN yhteyden. Kytke VPN yhteys pois päältä pelataksesi palvelimellamme.")
                end
            else
                deferrals.done("TeamFox: Meillä on ongelmia api kanssa.")
            end
        end)
    end
end)
