RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

OnDuty = false

RegisterServerEvent('rdx_policejob:givegun')
AddEventHandler("rdx_policejob:givegun", function(weapon)
  TriggerClientEvent('rdx_policejob:okgun', source, weapon)
end)

RegisterServerEvent("rdx_policejob:SVhasEnteredMarker")
AddEventHandler("rdx_policejob:SVhasEnteredMarker", function(currentZone)
    local _source = source
     local xPlayer = RDX.GetPlayerFromId(_source)
        if xPlayer.getJob().name == "lawman" and OnDuty then
            TriggerClientEvent('rdx_policejob:hasEnteredMarker', _source, currentZone)
        end   
end)

RegisterServerEvent('rdx_policejob:openmenusv')
AddEventHandler('rdx_policejob:openmenusv', function(source, cb)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
      if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:okleo', _source)
		else
			xPlayer.showNotification("You are <b style='color:red'>not</b> a Lawman","error")		
		end	
end)


RegisterServerEvent('rdx_policejob:menusv')
AddEventHandler('rdx_policejob:menusv', function(source, cb)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
       if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:okleomenu', _source)
		end
end)

RegisterServerEvent('rdx_policejob:openmenupedsv')
AddEventHandler('rdx_policejob:openmenupedsv', function(source, cb)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
       if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:okleoped', _source)
		end
end)

RegisterServerEvent('rdx_policejob:handcuffsv')
AddEventHandler('rdx_policejob:handcuffsv', function(target)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
        if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:handcuff', target)
		else
			print(('rdx_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end	
end)

RegisterServerEvent('rdx_policejob:handcuffsv2')
AddEventHandler('rdx_policejob:handcuffsv2', function(target)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
        if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:handcuff2', target)
		else
			print(('rdx_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)

RegisterServerEvent('rdx_policejob:hogtiesv')
AddEventHandler('rdx_policejob:hogtiesv', function(target)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
        if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:hogtie', target)
		else
			print(('rdx_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)

RegisterServerEvent('rdx_policejob:dragsv')
AddEventHandler('rdx_policejob:dragsv', function(target)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
        if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:drag', target, source)
		else
			print(('rdx_policejob: %s attempted to drag a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)

RegisterCommand("leo",function(source)
      local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
     if xPlayer.getJob().name == "lawman" and OnDuty then
			TriggerClientEvent('rdx_policejob:okleomenu', _source)
		else
			xPlayer.showNotification("You are <b style='color:red'>not</b> a Lawman","error")	
		end	
end)

RegisterCommand("duty",function(source)
    local _source = tonumber(source)
    local xPlayer = RDX.GetPlayerFromId(_source)
      if xPlayer.getJob().name == "lawman"  then
	 if OnDuty == false then
                      OnDuty = true                      
                       xPlayer.showNotification("You are now <b style='color:yellow'>On Duty</b> ","success")
                 else
                       OnDuty = false
                        xPlayer.showNotification("You are now <b style='color:red'>Off Duty</b> ","success")
                 end
      else
                xPlayer.showNotification("You are <b style='color:red'>not</b> a Lawman","error")			
      end	
end)

-- <b style='color:red'>TEXT</b> Change Text Color