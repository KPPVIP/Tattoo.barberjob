local currentTattoos = {}
local back = 1
local opacity = 1
local scaleType = nil
local scaleString = ""
ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
setPedSkin()
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			ClearPedDecorations(PlayerPedId())
				for k,v in pairs(tattooList) do
				SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end
			currentTattoos = tattooList
		end
	end)
end)




function OpenShopMenu(target, PlayercurrentTattoos)
	local elements = {}

	for k,v in pairs(Config.TattooCategories) do
		table.insert(elements, {label= v.name, value = v.value})
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop', {
		css = 'tattoo',
		title = _U('tattoos'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local currentLabel, currentValue = data.current.label, data.current.value

		if data.current.value then
			elements = {{label = _U('go_back_to_menu'), value = nil}}

			for k,v in pairs(Config.TattooList[data.current.value]) do
				table.insert(elements, {
					label = v.zone.. " - " ..v.name,
					value = k
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				css = 'tattoo',
				title = _U('tattoos') .. ' | '..currentLabel,
				align = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				if data2.current.value ~= nil then
					TriggerServerEvent('esx_tattooshop:purchaseTattoo', PlayercurrentTattoos, target, {collection = currentValue, texture = data2.current.value})

				else
					OpenShopMenu(target)
					TriggerServerEvent("esx_tattooshop:resetSkin", target)
				end

			end, function(data2, menu2)
				menu2.close()
				TriggerServerEvent("esx_tattooshop:setPedSkin", target)
				--setPedSkin()
			end, function(data2, menu2) -- when highlighted
				if data2.current.value ~= nil then
					--drawTattoo(data2.current.value, currentValue)
					TriggerServerEvent("esx_tattooshop:change", target, currentValue, data2.current.value)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
		TriggerServerEvent("esx_tattooshop:setPedSkin", target)
	end)
end


function setPedSkin()

	for k,v in pairs(currentTattoos) do
		SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end


function drawTattoo(current, collection)
	--SetEntityHeading(PlayerPedId(), 297.7296)
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end

	SetPedDecoration(PlayerPedId(), GetHashKey(collection), GetHashKey(Config.TattooList[collection][current].nameHash))
end

function cleanPlayer()
	ClearPedDecorations(PlayerPedId())
	for k,v in pairs(currentTattoos) do
		SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

--Use item
RegisterNetEvent("Iz_tattoo:tattoo_use")
AddEventHandler("Iz_tattoo:tattoo_use", function()
local target, distance = GetClosestPlayer()
				if(target ~= -1 and distance < 3.0) then
					TriggerServerEvent('esx_tattooshop:jecherche', target)
					
				else
					ESX.ShowNotification("Il n'y a personne autours.")
				end

end)
--



RegisterNetEvent("esx_tattooshop:getSkin")
AddEventHandler("esx_tattooshop:getSkin", function(target)
	TriggerEvent('skinchanger:getSkin', function(skin)
		skinBefore = skin
		TriggerServerEvent('esx_tattooshop:jecherche', skin, target, currentTattoos)
	end)
end)

local check = false
RegisterNetEvent("esx_tattooshop:setSkin")
AddEventHandler("esx_tattooshop:setSkin", function(target, PlayercurrentTattoos)
PlayercurrentTattoos = PlayercurrentTattoos
--currentTattoos = PlayercurrentTattoos
if check then
check =false
	OpenShopMenu(target, PlayercurrentTattoos)
else
	TriggerServerEvent('esx_tattooshop:jecherche', target)
check =true
	end
end)

RegisterNetEvent('esx_tattooshop:buySuccess')
AddEventHandler('esx_tattooshop:buySuccess', function()
	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
ESX.ShowNotification('~r~Vous êtes entrain de tatoué, CONCENTREZ VOUS!')
  RequestAnimDict('random@shop_tattoo')
        
    while not HasAnimDictLoaded('random@shop_tattoo') do
      Citizen.Wait(0)
    end
local ped = GetPlayerPed(-1)
	--ClearPedSecondaryTask(ped)
	FreezeEntityPosition(ped, true)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop_name = "v_ilev_ta_tatgun"
	Jointsupp = CreateObject(GetHashKey(prop_name), x, y, z,  true,  true, true)
	AttachEntityToEntity(Jointsupp, ped, GetPedBoneIndex(ped, 28422), -0.0, 0.03, 0, 0, -270.0, -20.0, true, true, false, true, 1, true)
	TaskPlayAnim(ped, "random@shop_tattoo", "artist_artist_finishes_up_his_tattoo", 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0) --player_artist_finishes_up_his_tattoo
			Wait(8000)
	ESX.ShowNotification("~g~Vous avez fini de tatouer, bravo!.")
	TriggerServerEvent('Iz_tattoo:removeencre')
	--table.insert(currentTattoos, tattoo)
	DeleteObject(Jointsupp)
	DetachEntity(Jointsupp, 1, true)
	ClearPedTasksImmediately(ped)
	ClearPedSecondaryTask(ped)
	FreezeEntityPosition(ped, false)
	else
	ESX.ShowNotification("~r~Et oui! il faut de l\'encre pour tatouer.")
	end
	end, 'encre')
end)


RegisterNetEvent("esx_tattooshop:change")
AddEventHandler("esx_tattooshop:change", function(collection, name)
	drawTattoo(name, collection)
end)


RegisterNetEvent("esx_tattooshop:resetSkin")
AddEventHandler("esx_tattooshop:resetSkin", function()
	cleanPlayer()
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)


RegisterNetEvent("esx_tattooshop:setPedSkin")
AddEventHandler("esx_tattooshop:setPedSkin", function()
	setPedSkin()
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				SetPedDecoration(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)


  

function GetClosestPlayer()
	local player = -1
	local minDistance = 1000.0

	local myCoords = GetEntityCoords(PlayerPedId())
	for _, id in pairs(GetActivePlayers()) do
		if(id ~= PlayerId()) then
		local ped = GetPlayerPed(id)
		local coords = GetEntityCoords(ped)
		local distance = #(myCoords-coords)

		if(distance < minDistance) then
			minDistance = distance
			player = GetPlayerServerId(id)
		end
		end
	end

	return player, minDistance
end
  
  