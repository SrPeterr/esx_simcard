if Config.Framework:match('ESX') then -- ESX Framework
	ESX = nil
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	ESX.RegisterUsableItem(Config.usableItem, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local hasItem = xPlayer.getInventoryItem(Config.phoneItem).count
		
		if Config.needPhone then
			if hasItem > 0 then
				TriggerClientEvent('esx_simcard:useItem', source)
			else
				TriggerClientEvent('esx:showNotification', source, Translation[Config.Locale]['noPhone'])
			end
		else
			TriggerClientEvent('esx_simcard:useItem', source)
		end
	end)

	ESX.RegisterServerCallback('esx_simcard:checkNumbers', function(source, cb, number)
		local src = source
		local xPlayer = ESX.GetPlayerFromId(src)
		
		MySQL.Async.fetchAll('SELECT * FROM ' .. Config.Database.numberDB .. ' WHERE '.. Config.Database.numberTB ..' = @phone', {
			['@phone'] = number
		}, function(numbers)
			if numbers[1] then
				cb(true)
			else
				cb(false)
			end
		end)
	end)

	RegisterServerEvent('esx_simcard:changeNumberDB')
	AddEventHandler('esx_simcard:changeNumberDB', function(newNumber)
		local src = source
		local xPlayer = ESX.GetPlayerFromId(src)
		
		MySQL.Async.execute('UPDATE ' .. Config.Database.numberDB .. ' SET ' .. Config.Database.numberTB .. ' = @newNumber WHERE ' .. Config.Database.identifierTB .. ' = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@newNumber'] = newNumber
			}, function() 
		end)

		updateNumber(src, newNumber) -- in config.lua

		if Config.removeItem then
			xPlayer.removeInventoryItem(Config.usableItem, 1)
		end
	end)
elseif Config.Framework:match('QBCore') then -- QBCore Framework
	local QBCore = exports['qb-core']:GetCoreObject()

	QBCore.Functions.CreateUseableItem(Config.usableItem, function(source)
		TriggerClientEvent('esx_simcard:hasItem', source)
	end)

	QBCore.Functions.CreateCallback('esx_simcard:checkNumbers', function(source, cb, number)
		local src = source
		local xPlayer = QBCore.Functions.GetPlayer(src)

		MySQL.Async.fetchAll('SELECT * FROM ' .. Config.Database.numberDB .. ' WHERE '.. Config.Database.numberTB ..' = @phone', {
			['@phone'] = number
		}, function(numbers)
			if numbers[1] then
				cb(true)
			else
				cb(false)
			end
		end)
	end)

	RegisterServerEvent('esx_simcard:changeNumberDB')
	AddEventHandler('esx_simcard:changeNumberDB', function(newNumber)
		local src = source
		local xPlayer = QBCore.Functions.GetPlayer(src)
		
		MySQL.Async.execute('UPDATE ' .. Config.Database.numberDB .. ' SET ' .. Config.Database.numberTB .. ' = @newNumber WHERE ' .. Config.Database.identifierTB .. ' = @identifier', {
			['@identifier'] = xPlayer.PlayerData.citizenid,
			['@newNumber'] = newNumber
			}, function() 
		end)

		updateNumber(src, newNumber) -- in config.lua

		if Config.removeItem then
			xPlayer.Functions.RemoveItem(Config.usableItem, 1)
		end
	end)
else
	print('ERROR: Framework not configured in config.lua')
end

---- Functions ----

function debug(msg)
	if Config.Debug then
		print(msg)
	end
end

---- GitHub Updater ----
function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

local CurrentVersion = GetCurrentVersion()
local resourceName = "^4["..GetCurrentResourceName().."]^0"

if Config.VersionChecker then
	PerformHttpRequest('https://raw.githubusercontent.com/Musiker15/esx_simcard/main/VERSION', function(Error, NewestVersion, Header)
		print("###############################")
    	if CurrentVersion == NewestVersion then
	    	print(resourceName .. '^2 ✓ Resource is Up to Date^0 - ^5Current Version: ^2' .. CurrentVersion .. '^0')
    	elseif CurrentVersion ~= NewestVersion then
        	print(resourceName .. '^1 ✗ Resource Outdated. Please Update!^0 - ^5Current Version: ^1' .. CurrentVersion .. '^0')
	    	print('^5Newest Version: ^2' .. NewestVersion .. '^0 - ^6Download here: ^9https://github.com/Musiker15/esx_simcard/releases/tag/v'.. NewestVersion .. '^0')
    	end
		print("###############################")
	end)
else
	print("###############################")
	print(resourceName .. '^2 ✓ Resource loaded^0')
	print("###############################")
end
