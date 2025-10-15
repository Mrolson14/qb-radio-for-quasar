local QBCore = exports['qb-core']:GetCoreObject()

-- ===============================
-- Radio Usable Item
-- ===============================
QBCore.Functions.CreateUseableItem("radio", function(source)
    TriggerClientEvent('qb-radio:use', source)
end)

-- ===============================
-- Restricted Channels
-- ===============================
for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end

-- ===============================
-- Radio Item Check (QS / QB / LJ)
-- ===============================
QBCore.Functions.CreateCallback('qb-radio:checkRadioItem', function(source, cb, item)
    local hasItem = false

    if GetResourceState('qs-inventory') == 'started' then
        -- ✅ For QS-Inventory (requires source)
        local success, result = pcall(function()
            return exports['qs-inventory']:HasItem(source, item)
        end)
        if success and result then
            hasItem = true
        end
    else
        -- ✅ Default fallback (QB or LJ inventory)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player and Player.Functions.GetItemByName(item) then
            hasItem = true
        end
    end

    cb(hasItem)
end)
