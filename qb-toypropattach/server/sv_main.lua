local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    for k, v in pairs(config.Toys) do
        QBCore.Functions.CreateUseableItem(k, function(source, item)
            TriggerClientEvent("UseToy", source, item.name)
        end) 
    end
end) 
