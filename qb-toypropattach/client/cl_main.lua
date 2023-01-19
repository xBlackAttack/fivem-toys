local lastProp = nil
local attachedProp = 0

RegisterCommand("prop", function(src, args)
    if lastProp == nil then 
        attachProp(args[1])
    else 
        removeAttachedProp()
        ClearPedTasks(PlayerPedId())
        ClearPedSecondaryTask(PlayerPedId())
    end
end)

function attachProp(name)
    removeAttachedProp()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, true)
    local myPropData = config.Toys[name]
    LoadAnimationDic(myPropData.animName)
    TaskPlayAnim(ped, myPropData.animName , myPropData.animDict, 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey(myPropData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    attachedProp = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(attachedProp, ped, GetPedBoneIndex(ped, 57005), myPropData.x, myPropData.y, myPropData.z, myPropData.xR, myPropData.yR, myPropData.zR, true, true, false, true, 1, true)
    lastProp = name
    if myPropData.emoteLoop then 
        TriggerEvent("qb-toyattach:loop", myPropData)
    end
end

RegisterNetEvent("qb-toyattach:loop")
AddEventHandler("qb-toyattach:loop", function(myPropData)
    local ped = PlayerPedId()
    while lastProp ~= nil do 
        Citizen.Wait(550)
        if IsEntityPlayingAnim(ped, myPropData.animName, myPropData.animDict, 3) == false then 
            if lastProp ~= nil then
                TaskPlayAnim(ped, myPropData.animName , myPropData.animDict, 5.0, -1, -1, 50, 0, false, false, false)
            end
        end
    end
end)

function removeAttachedProp()
	if DoesEntityExist(attachedProp) then
        lastProp = nil
		DeleteEntity(attachedProp)
        ClearPedTasks(PlayerPedId())
        ClearPedSecondaryTask(PlayerPedId())
		attachedProp = 0
	end
end

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 100 do
            timeout = timeout + 1
            Citizen.Wait(0)
        end
    end
end

function tprint (t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end 
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        attachedProp = 0
        DeleteEntity(attachedProp)
    end
end)

RegisterNetEvent("UseToy")
AddEventHandler("UseToy", function(name)
    if lastProp == nil then
        attachProp(name)
    else
    removeAttachedProp()
    end

end)