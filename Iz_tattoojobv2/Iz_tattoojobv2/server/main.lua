ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local PlayercurrentTattoos = {}

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)



RegisterServerEvent('esx_tattooshop:purchaseTattoo')
AddEventHandler('esx_tattooshop:purchaseTattoo', function(PlayercurrentTattoos, target, tattoo)
	local xPlayer = ESX.GetPlayerFromId(target)
		table.insert(PlayercurrentTattoos, tattoo)
		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier',
		{
			['@tattoos'] = json.encode(PlayercurrentTattoos),
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			
		end)
		TriggerClientEvent('esx_tattooshop:buySuccess', source)
end)

RegisterServerEvent('esx_tattooshop:jecherche')
AddEventHandler('esx_tattooshop:jecherche', function(target)
	local xPlayer = ESX.GetPlayerFromId(target)
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				PlayercurrentTattoos = json.decode(result[1].tattoos)
			end
		end)
						TriggerClientEvent("esx_tattooshop:setSkin", source, target, PlayercurrentTattoos)
		end)

------------------------------------------------------------------------------------------------------------------------ Target

RegisterServerEvent('esx_tattooshop:resetSkin')
AddEventHandler('esx_tattooshop:resetSkin', function(targetId)
TriggerClientEvent("esx_tattooshop:resetSkin", targetId)
end)

RegisterServerEvent('esx_tattooshop:setPedSkin')
AddEventHandler('esx_tattooshop:setPedSkin', function(targetId)
TriggerClientEvent("esx_tattooshop:setPedSkin", targetId)
end)








RegisterServerEvent('esx_tattooshop:setSkin')
AddEventHandler('esx_tattooshop:setSkin', function(skin, target, currentTattoos)
_source = source
targetid = target
TriggerClientEvent("esx_tattooshop:setSkin", source, skin, target, currentTattoos) -- _source
end)









RegisterServerEvent('esx_tattooshop:getSkin')
AddEventHandler('esx_tattooshop:getSkin', function(player)
target = player
_source = source
TriggerClientEvent("esx_tattooshop:getSkin", source, target)
end)

RegisterServerEvent('esx_tattooshop:change')
AddEventHandler('esx_tattooshop:change', function(targetId, collection, name)
TriggerClientEvent("esx_tattooshop:change", targetId, collection, name)
end)




RegisterServerEvent('esx_tattooshop:delete')
AddEventHandler('esx_tattooshop:delete', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= 50000 then
		xPlayer.removeMoney(50000)
		MySQL.Async.execute('UPDATE users SET tattoos = "{}" WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			TriggerClientEvent('esx_tattooshop:reloadTattoos', _source)
			xPlayer.showNotification("~b~Usunięto wszystkie tatuaże")
		end)
	else
		xPlayer.showNotification("~r~Nie masz wystarczająco gotówki")
	end
end)


-- Item use
ESX.RegisterUsableItem('tatoo_auto', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Iz_tattoo:tattoo_use', source)
	TriggerClientEvent('esx:showNotification', source, ('Tu as utilisé ~g~1x Machine tattoo'))
end)

RegisterServerEvent('Iz_tattoo:removeencre')
AddEventHandler('Iz_tattoo:removeencre', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('encre', 1)
end)