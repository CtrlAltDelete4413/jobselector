local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('jobselector:setJob', function(job)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetJob(job, 0)
        TriggerClientEvent('QBCore:Notify', src, "You are now a " .. job .. "!", "success")
    end
end)

RegisterNetEvent('jobselector:removeJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetJob('unemployed', 0)
        TriggerClientEvent('QBCore:Notify', src, "You have resigned from your job!", "error")
    end
end)
