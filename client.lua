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

    exports.ox_target:addLocalEntity(npc, {
        {
            name = "job_selector",
            label = "Talk to Job Manager",
            icon = "fa-solid fa-briefcase",
            event = "jobselector:openMenu"
        }
    })
end)

RegisterNetEvent('jobselector:openMenu', function()
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

    table.insert(options, {
        title = "Resign from Job",
        description = "Remove your current job",
        icon = "fa-solid fa-user-slash",
        event = "jobselector:requestRemoveJob"
    })

    lib.registerContext({
        id = 'job_selector_menu',
        title = 'Job Selector',
        options = options
    })
    lib.showContext('job_selector_menu')
end)

RegisterNetEvent('jobselector:requestSetJob', function(job)
    TriggerServerEvent('jobselector:setJob', job)
end)

RegisterNetEvent('jobselector:requestRemoveJob', function()
    TriggerServerEvent('jobselector:removeJob')
end)
