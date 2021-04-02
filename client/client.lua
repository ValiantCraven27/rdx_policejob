RDX  = nil
Citizen.CreateThread(function()          
	while ESX == nil do
		TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
		Citizen.Wait(0)
	end

while RDX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = RDX.GetPlayerData()          
end)

RegisterNetEvent('rdx:playerLoaded')
AddEventHandler('rdx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('rdx:setJob')
AddEventHandler('rdx:setJob', function(job)
  PlayerData.job = job
end)


local isHandcuffed, isHandcuffed2, isHandcuffed3 = false, false, false
local PlayerData, leo, dragStatus, currentTask = {}, {}, {}, {}
dragStatus.isDragged = false
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil
local active = false
local selectPed = nil
local LeoPrompt, PedPrompt

function SetupLeoPrompt()
    Citizen.CreateThread(function()
        local str = 'Open Gun Menu'
        LeoPrompt = PromptRegisterBegin()
        PromptSetControlAction(LeoPrompt, 0xE8342FF2) -- Down
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(LeoPrompt, str)
        PromptSetEnabled(LeoPrompt, false)
        PromptSetVisible(LeoPrompt, false)
        PromptSetHoldMode(LeoPrompt, true)
        PromptRegisterEnd(LeoPrompt)
    end)
end

function SetupPedPrompt()
    Citizen.CreateThread(function()
        local str = 'Open Ped Menu'
        PedPrompt = PromptRegisterBegin()
        PromptSetControlAction(PedPrompt, 0x6319DB71) -- UP
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PedPrompt, str)
        PromptSetEnabled(PedPrompt, false)
        PromptSetVisible(PedPrompt, false)
        PromptSetHoldMode(PedPrompt, true)
        PromptRegisterEnd(PedPrompt)
    end)
end

RegisterNetEvent('rdx_policejob:hasEnteredMarker')
AddEventHandler('rdx_policejob:hasEnteredMarker', function(zone)
      SetupPedPrompt()
      SetupLeoPrompt()         
    currentZone     = zone   
end)

AddEventHandler('rdx_policejob:hasExitedMarker', function(zone)
    if active == true then
        PromptSetEnabled(LeoPrompt, false)
        PromptSetVisible(LeoPrompt, false)
        PromptSetEnabled(PedPrompt, false)
        PromptSetVisible(PedPrompt, false)
        active = false
    end
        currentZone = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
		local isInMarker, letSleep, currentZone = false, true

        for k,v in ipairs(Config.Offices) do 
            local VectorCoords = vector3(coords)
            local ShopCoords = vector3(v.x, v.y, v.z)
            local distance = Vdist(ShopCoords, VectorCoords)
            if distance < 20.0 then
                Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.75, 100, 50, 75, 75, false, true, 2, false, false, false, false)
				letSleep = false
                if distance < 1.5 then
					isInMarker  = true
					currentZone = v.name
					lastZone    = v.name
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            TriggerServerEvent('rdx_policejob:SVhasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('rdx_policejob:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	while true do
                             
		Citizen.Wait(0)
		if currentZone then
  
			if active == false then
                PromptSetEnabled(PedPrompt, true)
                PromptSetVisible(PedPrompt, true)
                PromptSetEnabled(LeoPrompt, true)
                PromptSetVisible(LeoPrompt, true)
               
                active = true
            end
         
            if PromptHasHoldModeCompleted(PedPrompt) then
                PromptSetEnabled(LeoPrompt, false)
                PromptSetVisible(LeoPrompt, false)
                PromptSetEnabled(PedPrompt, false)
                PromptSetVisible(PedPrompt, false)
                active = false
                
                player = GetPlayerServerId()
                TriggerServerEvent("rdx_policejob:openmenupedsv", player, function(cb) end)      
   
				currentZone = nil
			end
            if PromptHasHoldModeCompleted(LeoPrompt) then
                PromptSetEnabled(LeoPrompt, false)
                PromptSetVisible(LeoPrompt, false)
                PromptSetEnabled(PedPrompt, false)
                PromptSetVisible(PedPrompt, false)
                active = false
                
                player = GetPlayerServerId()
                TriggerServerEvent("rdx_policejob:openmenusv", player, function(cb) end)      
   
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('leo.gun', "Lawman Guns")
    WarMenu.SetMenuX('leo.gun', 0.75)
    WarMenu.SetMenuY('leo.gun',  0.28)  
       
    while true do      
            DisableControlAction(0, 0x24978A28, true) -- H
        if WarMenu.IsMenuOpened('leo.gun') then
            if WarMenu.Button("Double-Action Revolver ") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_REVOLVER_DOUBLEACTION")           
            elseif WarMenu.Button("Semi-auto Pistol") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_PISTOL_SEMIAUTO")
            elseif WarMenu.Button("Pump Shotgun") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_SHOTGUN_PUMP")
            elseif WarMenu.Button("Carbine Repeater") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_REPEATER_CARBINE")
            elseif WarMenu.Button("Lasso") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_LASSO")          
            elseif WarMenu.Button("Knife") then
                TriggerServerEvent("rdx_policejob:givegun", "WEAPON_MELEE_KNIFE")
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
           
    end
         EnableControlAction(0, 0x24978A28, true) -- H
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('leo.menu', "Lawman Menu")
    WarMenu.SetMenuX('leo.menu', 0.75)
    WarMenu.SetMenuY('leo.menu',  0.28)
    while true do
           DisableControlAction(0, 0x24978A28, true) -- H
        if WarMenu.IsMenuOpened('leo.menu') then
            if WarMenu.Button('Soft Cuff') then
                local closestPlayer, closestDistance = GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('rdx_policejob:handcuffsv2', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Drag') then
                local closestPlayer, closestDistance = GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('rdx_policejob:dragsv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Ankle Irons') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('rdx_policejob:handcuffsv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Lock Hogtie') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('rdx_policejob:hogtiesv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    end
    EnableControlAction(0, 0x24978A28, true) -- H
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('leo.ped', "Lawman Models")
    WarMenu.SetMenuX('leo.ped', 0.75)
    WarMenu.SetMenuY('leo.ped',  0.28)   
     
    while true do
          DisableControlAction(0, 0x24978A28, false) -- H
        if WarMenu.IsMenuOpened('leo.ped') then               
            if WarMenu.Button("A_M_M_ARMDEPUTYRESIDENT_01") then
                         selectPed = 'A_M_M_ARMDEPUTYRESIDENT_01'    
                          spawnModel(selectPed)                         
            elseif WarMenu.Button("A_M_M_ASBDEPUTYRESIDENT_01") then
                         selectPed = 'A_M_M_ASBDEPUTYRESIDENT_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("A_M_M_RHDDEPUTYRESIDENT_01") then
                         selectPed = 'A_M_M_RHDDEPUTYRESIDENT_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("A_M_M_VALDEPUTYRESIDENT_01") then
                         selectPed = 'A_M_M_VALDEPUTYRESIDENT_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_ASBDEPUTY_01") then
                         selectPed = 'CS_ASBDEPUTY_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_rhodeputy_01") then
                         selectPed = 'CS_rhodeputy_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_RhoDeputy_02") then
                         selectPed = 'CS_RhoDeputy_02'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_SHERIFFFREEMAN") then
                         selectPed = 'CS_SHERIFFFREEMAN'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_SheriffOwens") then
                         selectPed = 'CS_SheriffOwens'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_VALDEPUTY_01") then
                         selectPed = 'CS_VALDEPUTY_01'
                         spawnModel(selectPed)    
            elseif WarMenu.Button("CS_VALSHERIFF") then
                         selectPed = 'CS_VALSHERIFF'
                         spawnModel(selectPed)    
            end
                    
             WarMenu.Display()
          end
        Citizen.Wait(0)        
    end
   EnableControlAction(0, 0x24978A28, true) -- H
   
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Citizen.Wait(0)
		if isHandcuffed or isHandcuffed2 then
			playerPed = PlayerPedId()
			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed or isHandcuffed2 or isHandcuffed3 then
			DisableControlAction(0, 0xB2F377E8, true) -- Attack
			DisableControlAction(0, 0xC1989F95, true) -- Attack 2
			DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
			DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
			DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
			DisableControlAction(0, 0x8FFC75D6, true) -- Shift
			DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
                                                DisableControlAction(0, 0xCEFD9220, true) -- E
                                                DisableControlAction(0, 0xF3830D8E, true) -- J
                                                DisableControlAction(0, 0x80F28E95, true) -- L
                                                DisableControlAction(0, 0xDB096B85, true) -- CTRL
                                                DisableControlAction(0, 0xE30CD707, true) -- R
                                               -- DisableControlAction(0, 0x24978A28, true) -- H


		else
			Citizen.Wait(500)
		end
	end
end)

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
	local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
    end
    
	for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end


RegisterNetEvent('rdx_policejob:okleo')
AddEventHandler('rdx_policejob:okleo', function() 
    WarMenu.OpenMenu('leo.gun')
    WarMenu.Display()
end)

RegisterNetEvent('rdx_policejob:okleomenu')
AddEventHandler('rdx_policejob:okleomenu', function() 
    WarMenu.OpenMenu('leo.menu')
    WarMenu.Display()
end)

RegisterNetEvent('rdx_policejob:okleoped')
AddEventHandler('rdx_policejob:okleoped', function() 
    WarMenu.OpenMenu('leo.ped')
    WarMenu.Display()
end)

RegisterNetEvent('rdx_policejob:okgun')
AddEventHandler('rdx_policejob:okgun', function(kek) 
    GiveWeaponToPed_2(PlayerPedId(), GetHashKey(kek), 500, false, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
    local msg = "Weapon Recieved!"
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end)


RegisterNetEvent('rdx_policejob:handcuff')
AddEventHandler('rdx_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed then
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)
        elseif not isHandcuffed then
            if isHandcuffed2 then
                FreezeEntityPosition(playerPed, false)
            else
                ClearPedSecondaryTask(playerPed)
                SetEnableHandcuffs(playerPed, false)
                DisablePlayerFiring(playerPed, false)
                SetPedCanPlayGestureAnims(playerPed, true)
                FreezeEntityPosition(playerPed, false)
                DisplayRadar(true)
            end
		end
	end)
end)

RegisterNetEvent('rdx_policejob:handcuff2')
AddEventHandler('rdx_policejob:handcuff2', function()
	isHandcuffed2 = not isHandcuffed2
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed2 then
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
        elseif not isHandcuffed2 then
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            DisplayRadar(true)
            isHandcuffed = false
		end
	end)
end)

RegisterNetEvent('rdx_policejob:hogtie')
AddEventHandler('rdx_policejob:hogtie', function()
	isHandcuffed3 = not isHandcuffed3
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed3 then
            TaskKnockedOutAndHogtied(playerPed, false, false)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
        elseif not isHandcuffed3 then
            ClearPedTasksImmediately(playerPed, true, false)
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('rdx_policejob:drag')
AddEventHandler('rdx_policejob:drag', function(copId)
	dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)


function spawnModel(selectPed)
local ped = selectPed
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(300)
			end
                                                DoScreenFadeOut(500)			
                                                RDX.ShowNotification("Changing Lawman Model", "success")                                            
			SetPedAsCop(PlayerPedId(), true)
                                                Citizen.InvokeNative(0x704C908E9C405136, PlayerPedId())
			SetPlayerModel(GetPlayerPed(-1), hash, 0)
                                                SetPedRandomComponentVariation(PlayerPedId(),0)
                                                SetEntityAsMissionEntity(PlayerPedId(), true, true) 
                                                selectPed = 0
                                                DoScreenFadeIn(500)
		end

