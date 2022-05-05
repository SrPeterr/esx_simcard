if Config.Framework:match('ESX') then -- ESX Framework
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)

    RegisterNetEvent('esx_simcard:useItem')
    AddEventHandler('esx_simcard:useItem', function()
        local playerPed = PlayerPedId()
        local genNumber = genNumber()

        ESX.TriggerServerCallback('esx_simcard:checkNumbers', function(isExisting)
            if not isExisting then
                TriggerServerEvent('esx_simcard:changeNumberDB', genNumber)
            else
                ESX.ShowNotification(Translation[Config.Locale]['numberExist'])
            end
        end, genNumber)
    end)
elseif Config.Framework:match('QBCore') then -- QBCore Framework
    local QBCore = exports['qb-core']:GetCoreObject()
	--[[ Citizen.CreateThread(function()
   		while QBCore == nil do
   			TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
   			Citizen.Wait(0)
   		end
	end) ]]

    RegisterNetEvent('esx_simcard:hasItem')
    AddEventHandler('esx_simcard:hasItem', function(source)
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasItem)
            if hasItem then
                TriggerEvent('esx_simcard:useItem', source)
            else
                QBCore.Functions.Notify(Translation[Config.Locale]['noPhone'], 'error', 5000)
            end 
        end, Config.phoneItem)
    end)

    RegisterNetEvent('esx_simcard:useItem')
    AddEventHandler('esx_simcard:useItem', function()
        local playerPed = PlayerPedId()
        local genNumber = genNumber()

        QBCore.Functions.TriggerCallback('esx_simcard:checkNumbers', function(isExisting)
            if not isExisting then
                TriggerServerEvent('esx_simcard:changeNumberDB', genNumber)
            else
                QBCore.Functions.Notify(Translation[Config.Locale]['numberExist'], 'primary', 5000)
            end
        end, isExisting)
    end)
else
    print('ERROR: Framework not configured in config.lua')
end

---- Functions ----

function genNumber()
    local random = math.random(000001, 999999)
    local number = Config.StartingDigit .. random
    return number
end

function debug(msg)
	if Config.Debug then
		print(msg)
	end
end
