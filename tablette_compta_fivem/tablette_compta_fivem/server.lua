local DATA_FILE = 'data.json'
local ledger = {
    balance = tonumber(Config.InitialBalance) or 0,
    transactions = {}
}

local function roundMoney(value)
    return math.floor(value * 100 + 0.5) / 100
end

local function saveLedger()
    local encoded = json.encode(ledger)
    SaveResourceFile(GetCurrentResourceName(), DATA_FILE, encoded, -1)
end

local function loadLedger()
    local raw = LoadResourceFile(GetCurrentResourceName(), DATA_FILE)
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then
            ledger.balance = roundMoney(tonumber(decoded.balance) or Config.InitialBalance or 0)
            ledger.transactions = type(decoded.transactions) == 'table' and decoded.transactions or {}
            return
        end
    end

    ledger.balance = roundMoney(tonumber(Config.InitialBalance) or 0)
    ledger.transactions = {}
    saveLedger()
end

local function notify(src, message, kind)
    TriggerClientEvent('tabletcompta:notify', src, message, kind or 'info')
end

local function hasPermission(src)
    if not Config.RequireAcePermission then
        return true
    end
    return IsPlayerAceAllowed(src, Config.AcePermission)
end

local function sendData(src)
    TriggerClientEvent('tabletcompta:receiveData', src, {
        balance = ledger.balance,
        transactions = ledger.transactions
    })
end

RegisterNetEvent('tabletcompta:requestData', function()
    local src = source
    sendData(src)
end)

RegisterNetEvent('tabletcompta:transaction', function(payload)
    local src = source

    if type(payload) ~= 'table' then
        notify(src, 'Requete invalide.', 'error')
        return
    end

    if not hasPermission(src) then
        notify(src, 'Tu n’as pas la permission de modifier la comptabilite.', 'error')
        return
    end

    local transactionType = payload.type
    if transactionType ~= 'entree' and transactionType ~= 'sortie' then
        notify(src, 'Type d’operation invalide.', 'error')
        return
    end

    local amount = tonumber(payload.amount)
    if not amount or amount ~= amount or amount <= 0 or amount > 100000000 then
        notify(src, 'Montant invalide.', 'error')
        return
    end
    amount = roundMoney(amount)
    if amount <= 0 then
        notify(src, 'Le montant doit etre superieur a zero.', 'error')
        return
    end

    if transactionType == 'sortie' and amount > ledger.balance then
        notify(src, 'Solde insuffisant pour cette sortie.', 'error')
        return
    end

    local description = tostring(payload.description or '')
    description = description:gsub('[\r\n]', ' '):sub(1, 100)
    if description:gsub('%s', '') == '' then
        description = transactionType == 'entree' and 'Entree d’argent' or 'Sortie d’argent'
    end

    if transactionType == 'entree' then
        ledger.balance = roundMoney(ledger.balance + amount)
    else
        ledger.balance = roundMoney(ledger.balance - amount)
    end

    table.insert(ledger.transactions, 1, {
        id = os.time() .. '-' .. tostring(math.random(1000, 9999)),
        type = transactionType,
        amount = amount,
        description = description,
        date = os.date('%d/%m/%Y %H:%M:%S'),
        player = GetPlayerName(src) or ('ID ' .. tostring(src))
    })

    while #ledger.transactions > (tonumber(Config.MaxTransactions) or 200) do
        table.remove(ledger.transactions)
    end

    saveLedger()
    sendData(src)
    notify(src, 'Operation enregistree.', 'success')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadLedger()
        print(('[tabletcompta] Comptabilite chargee. Solde: %.2f'):format(ledger.balance))
    end
end)
