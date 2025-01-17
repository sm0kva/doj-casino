local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.AddItem('casino_goldchip', {
    name = 'casino_goldchip',
    weight = 0,
    type = 'item',
    image = 'casino_goldchip.png',
    unique = false,
    useable = false,
    shouldClose = false,
    combinable = nil,
    description = 'Casino Chip'
})

local quantity = 0
local ItemList = {
    ["casino_goldchip"] = 1,
}

RegisterServerEvent("qb-casino:server:GoldSell")
AddEventHandler("qb-casino:server:GoldSell", function()
    local src = source
    local price = Config.casinoChipPrice
    local Player = QBCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casino_goldchip")
    if xItem ~= nil then
        local quantity = 0
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    quantity = quantity + Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        price = price * quantity
        Player.Functions.AddMoney(Config.payment, price, "sold-casino-chips")
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['casino_goldchip'], "remove", quantity)
        TriggerClientEvent('QBCore:Notify', src, "You sold "..quantity.." Gold chips for $"..price)
        TriggerEvent('qb-log:server:CreateLog', 'guedesteste', 'Dinheiro Venda | '..Player.PlayerData.name, 'default', quantity.." fichas de ouro por "..price.."€")
        TriggerClientEvent("doj:casinoChipMenu", src)
		quantity = 0
    else
        TriggerClientEvent('QBCore:Notify', src, "You dont have any gold casino chips...", "error") 
        TriggerClientEvent("doj:casinoChipMenu", src)
    end
end)


RegisterNetEvent("doj:server:purchaseMembership", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MembershipCheck = Player.Functions.GetItemByName('casino_member')
    if MembershipCheck ~= nil then
        TriggerClientEvent('doj:casinoMembershipMenu', src)
        TriggerClientEvent('QBCore:Notify', src, 'You already have a Membership', 'error')
    else
	    if Player.Functions.AddItem('casino_member', 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['casino_member'], "add", 1)
            TriggerClientEvent('doj:casinoMembershipMenu', src)

        end
    end
end)

RegisterNetEvent("doj:server:purchaseVIPMembership", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local VIPMembershipCheck = Player.Functions.GetItemByName('casino_vip')
    if VIPMembershipCheck ~= nil then
        TriggerClientEvent('doj:casinoMembershipMenu', src)
        TriggerClientEvent('QBCore:Notify', src, 'You already have a Membership', 'error')
    else
	    if Player.Functions.AddItem('casino_vip', 1, false, info) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['casino_vip'], "add", 1)
            TriggerClientEvent('doj:casinoMembershipMenu', src)

        end
    end 
end)


QBCore.Functions.CreateCallback('doj:server:HasCasinoMembership', function(source, cb)
    cb(true)
end)

QBCore.Functions.CreateCallback('doj:server:HasVIPMembership', function(source, cb)
    cb(true)
end)
