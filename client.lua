local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    RequestModel(Config.JobNPC.model)
    while not HasModelLoaded(Config.JobNPC.model) do
        Wait(10)
    end

    local npc = CreatePed(4, Config.JobNPC.model, Config.JobNPC.coords.x, Config.JobNPC.coords.y, Config.JobNPC.coords.z - 1.0, Config.JobNPC.coords.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    if Config.Target == "ox" then
        exports.ox_target:addLocalEntity(npc, {
            {
                name = "job_selector",
                label = "Talk to Job Manager",
                icon = "fa-solid fa-briefcase",
                event = "jobselector:openMenu"
            }
        })
    else
        exports['qb-target']:AddTargetEntity(npc, {
            options = {
                {
                    type = "client",
                    event = "jobselector:openMenu",
                    icon = "fa-solid fa-briefcase",
                    label = "Talk to Job Manager"
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('jobselector:openMenu', function()
    local Player = QBCore.Functions.GetPlayerData()
    local options = {}
    
    for _, job in ipairs(Config.JobList) do
        table.insert(options, {
            title = job.label,
            description = "Select this job",
            icon = "fa-solid fa-briefcase",
            event = "jobselector:requestSetJob",
            args = job.value
        })
    end
    
    local removeJobOptions = {}
    if Player.job and Player.job.name ~= "unemployed" then
        table.insert(removeJobOptions, {
            title = "Resign from " .. Player.job.label,
            description = "Remove this job",
            icon = "fa-solid fa-user-slash",
            event = "jobselector:requestRemoveJob",
            args = Player.job.name
        })
    end
    
    if #removeJobOptions > 0 then
        table.insert(options, {
            title = "Resign from Job",
            description = "Choose a job to resign from",
            icon = "fa-solid fa-user-slash",
            event = "jobselector:openRemoveJobMenu"
        })
    end
    
    lib.registerContext({
        id = 'job_selector_menu',
        title = 'Job Selector',
        options = options
    })
    lib.showContext('job_selector_menu')
end)

RegisterNetEvent('jobselector:openRemoveJobMenu', function()
    local Player = QBCore.Functions.GetPlayerData()
    local options = {}
    
    if Player.job and Player.job.name ~= "unemployed" then
        table.insert(options, {
            title = "Resign from " .. Player.job.label,
            description = "Confirm job removal",
            icon = "fa-solid fa-user-slash",
            event = "jobselector:requestRemoveJob",
            args = Player.job.name
        })
    end
    
    lib.registerContext({
        id = 'remove_job_menu',
        title = 'Remove Job',
        options = options
    })
    lib.showContext('remove_job_menu')
end)

RegisterNetEvent('jobselector:requestSetJob', function(job)
    TriggerServerEvent('jobselector:setJob', job)
end)

RegisterNetEvent('jobselector:requestRemoveJob', function(job)
    TriggerServerEvent('jobselector:removeJob', job)
end)