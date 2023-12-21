local QBCore = nil

local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('qb-gardencleaner:givemoney')
AddEventHandler('qb-gardencleaner:givemoney', function(JobsToDo, SetRandomLocation)
    local Player = QBCore.Functions.GetPlayer(source)
    local curexp = Player.PlayerData.metadata['jobrep']["gardencleaner"]
    if curexp ~= 100 or curexp < 100 then 
        Player.Functions.AddJobReputation(JobsToDo*Config.JobWork[SetRandomLocation].XPForOnePoint, "gardencleaner")
    end
    Player.Functions.AddMoney(Config.PaymentType, JobsToDo*Config.JobWork[SetRandomLocation].PayForOnePoint)
end)

print([[
    all rights to 76B Store and 76b_qht
    Discord: https://discord.gg/XQ4U58vt48]])


--RegisterCommand('setrep10', function(source, args, RawCommand)
--    local Player = QBCore.Functions.GetPlayer(source)
--    Player.Functions.SetJobReputation(11, "gardencleaner")
--end)
--
--RegisterCommand('setrep30', function(source, args, RawCommand)
--    local Player = QBCore.Functions.GetPlayer(source)
--    Player.Functions.SetJobReputation(31, "gardencleaner")
--end)
--
--RegisterCommand('setrep50', function(source, args, RawCommand)
--    local Player = QBCore.Functions.GetPlayer(source)
--    Player.Functions.SetJobReputation(51, "gardencleaner")
--end)

