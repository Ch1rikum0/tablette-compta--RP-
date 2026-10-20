local tabletOpen = false

local function setTablet(state)
    tabletOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = state and 'open' or 'close',
        externalUrl = Config.ExternalUrl
    })

    if state then
        TriggerServerEvent('tabletcompta:requestData')
    end
end

RegisterCommand(Config.OpenCommand, function()
    setTablet(not tabletOpen)
end, false)

RegisterNetEvent('tabletcompta:receiveData', function(data)
    SendNUIMessage({
        action = 'data',
        data = data,
        externalUrl = Config.ExternalUrl
    })
end)

RegisterNetEvent('tabletcompta:notify', function(message, kind)
    SendNUIMessage({
        action = 'notify',
        message = message or '',
        kind = kind or 'info'
    })
end)

RegisterNUICallback('close', function(_, cb)
    setTablet(false)
    cb({ ok = true })
end)

RegisterNUICallback('requestData', function(_, cb)
    TriggerServerEvent('tabletcompta:requestData')
    cb({ ok = true })
end)

RegisterNUICallback('transaction', function(data, cb)
    TriggerServerEvent('tabletcompta:transaction', {
        type = data.type,
        amount = data.amount,
        description = data.description
    })
    cb({ ok = true })
end)

RegisterNUICallback('openExternal', function(_, cb)
    local url = Config.ExternalUrl or ''
    if url:match('^https://') or url:match('^http://') then
        -- Le lien est defini dans config.lua, pas fourni par l'utilisateur NUI.
        SendNUIMessage({ action = 'externalUrl', externalUrl = url })
        cb({ ok = true, url = url })
    else
        cb({ ok = false, error = 'URL externe invalide. Utilise http:// ou https://.' })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)
