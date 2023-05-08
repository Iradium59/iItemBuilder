ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local itemArray = {
    name = '',
    label = '',
    weight = ''
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

local function iItemBuilderKeyboard(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


local function itemBuilderMenu()
    local main = RageUI.CreateMenu("ItemBuilder", ItemBuilder.serverName)
    main:SetRectangleBanner(11,11,11,1)
    RageUI.Visible(main, not RageUI.Visible(main))
    while main do
        Citizen.Wait(0)
        RageUI.IsVisible(main, true, true, true, function()
            RageUI.Separator('↓ ~y~Créer un Item~s~ ↓')
            RageUI.ButtonWithStyle('→ Nom de l\'item', nil, {RightLabel = itemArray.name}, true, function(Hovered,Active, Selected)
                if Selected then
                    itemArray.name = iItemBuilderKeyboard("Nom de l'item ?", '' ,15)
                end
            end)
            RageUI.ButtonWithStyle('→ Label de l\'item', nil, {RightLabel = itemArray.label}, true, function(Hovered,Active, Selected)
                if Selected then
                    itemArray.label = iItemBuilderKeyboard("Label de l'item ?", '' ,15)
                end
            end)
            RageUI.ButtonWithStyle('→ Poids de l\'item', nil, {RightLabel = itemArray.weight}, true, function(Hovered,Active, Selected)
                if Selected then
                    local weight = iItemBuilderKeyboard('Poids de l\'item', '',3)
                    if tonumber(weight) then
                        itemArray.weight = weight
                    else
                        ESX.ShowNotification('Le poid doit être un nombre !')
                    end
                end
            end)
            RageUI.Separator('↓ ~y~Actions~s~ ↓')
            RageUI.ButtonWithStyle('~g~Valider', nil, {}, true, function(Hovered,Active, Selected)
                if Selected then
                    if itemArray.name ~= '' and itemArray.label ~= '' and itemArray.weight ~= '' then 
                        ESX.TriggerServerCallback('iItemBuilder:getItem', function(itemExist)
                            if itemExist then
                                ESX.ShowNotification('l\'item éxiste déja !')
                            else
                                TriggerServerEvent('iItemBuilder:AddItem', itemArray)
                                RageUI.CloseAll()
                                itemArray = {}
                            end
                        end, itemArray.name)
                    else
                        ESX.ShowNotification('Renseigné tout les champs')
                    end
                end
            end)
            RageUI.ButtonWithStyle('~r~Annuler', nil, {}, true, function(Hovered,Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    itemArray = {}
                end
            end)
        
        end, function()
        end)

        if not RageUI.Visible(main) then
            main = RMenu:DeleteType('main', true)
        end
    end
end


RegisterNetEvent('iItemBuilder:OpenMenu')
AddEventHandler('iItemBuilder:OpenMenu', function()
    itemBuilderMenu()
end)