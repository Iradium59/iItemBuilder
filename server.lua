ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterCommand("itembuilder", function(source)
    if source == 0 then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    for k, v in pairs(ItemBuilder.grade) do
        if v == group then
            TriggerClientEvent('iItemBuilder:OpenMenu', source)
        end
    end
end, false)

ESX.RegisterServerCallback("iItemBuilder:getItem", function(source, cb, item)
    MySQL.Async.fetchAll('SELECT * FROM items WHERE name LIKE @item', {
        ['@item'] = item
    }, function(result)
        if result[1] then
            cb(true) 
        else
            cb(false)
        end
    end)
end)


RegisterServerEvent('iItemBuilder:AddItem')
AddEventHandler('iItemBuilder:AddItem', function(Array)
    MySQL.Async.execute('INSERT INTO items (name, label, weight, rare, can_remove) VALUES (@name, @label, @weight, @rare, @can_remove)', {
        ['@name'] = Array.name,
        ['@label'] = Array.label,
        ['@weight'] = Array.weight,
        ['@rare'] = 0,
        ['@can_remove'] = 1
    }, function(change)
        print('item ajouté avec succés')
    end)
end)
