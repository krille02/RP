ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('es:addGroupCommand', 'emote', 'admin', function(source, args, user)
	TriggerClientEvent('admin_commands:emote', source, args)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Get current player coordinates"})


TriggerEvent('es:addGroupCommand', 'repair', 'admin', function(source, args, user)
	TriggerClientEvent('admin_commands:repair', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Починить автомобиль"})

TriggerEvent('es:addGroupCommand', 'addpassport', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)

	if #args >= 1 then
		local target = tonumber(args[1])
		if target ~= nil then
			xPlayer = ESX.GetPlayerFromId(target)
		end
	end

	TriggerEvent("esx_inventory:createItem", "passport", {}, 1, 0, function(item)
		TriggerEvent("esx_inventory:addItem", "pocket", xPlayer.identifier, item, function(ret)
		end)
	end)

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Получить паспорт игрока"})

TriggerEvent('es:addGroupCommand', 'sethunger', 'admin', function(source, args, user)
	TriggerClientEvent('esx_status:set', source, 'hunger', tonumber(args[1]) or 0)

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Установить значение сытости"})

TriggerEvent('es:addGroupCommand', 'setthirst', 'admin', function(source, args, user)
	TriggerClientEvent('esx_status:set', source, 'thirst', tonumber(args[1]) or 0)

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Установить значение жажды"})

TriggerEvent('es:addGroupCommand', 'setmodel', 'admin', function(source, args, user)

	if #args >= 2 then
		local target = tonumber(args[1])
		if target ~= nil then
			xPlayer = ESX.GetPlayerFromId(target)
			if xPlayer ~= nil then
				TriggerClientEvent('admin_commands:setmodel', xPlayer.source, args[2])
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Игрок не найден на сервере.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Неверный ID пользователя.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Неверное число аргументов.' } })
	end

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Установить хэш игрока", params = {{name = "userid", help = "ID игрока"},{name = "hash", help = "имя хэша или skin"}}})


TriggerEvent('es:addGroupCommand', 'spawncar', 'admin', function(source, args, user)
	local plate = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = false and fourrieremecano = false', {
	}, function(results)

		for i=1,#results do
			local res = results[i]
			if res.plate == plate then
				local props = json.decode(res.vehicle)
				TriggerClientEvent('admin_commands:spawncar', source, props)
				break
			end
		end
	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Заспавнить автомобиль игрока", params = {{name = "plate", help = "Автомобильный номер"}}})


TriggerEvent('es:addGroupCommand', 'setfuel', 'admin', function(source, args, user)
	if #args < 1 or tonumber(args[1]) == nil then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Incorrect fuel amount' } })
	end

	TriggerClientEvent('admin_commands:setfuel', source, tonumber(args[1]))

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Установить количество топлива в транспорте"})

-- ADMIN SERVER EVENTS

--RegisterServerEvent('admin_commands:setmoney') -- do not allow to set money from client
AddEventHandler('admin_commands:setmoney', function(_source, target, money_type, money_action, money_amount)
	local xPlayer = ESX.GetPlayerFromId(target)

	if target and money_type and money_amount and xPlayer ~= nil then
		if money_type == 'cash' then
			if money_action == 'set' then
				xPlayer.setMoney(money_amount)
			elseif money_action == 'add' then
				xPlayer.addMoney(money_amount)
			elseif money_action == 'remove' then
				xPlayer.removeMoney(money_amount)
			end
		elseif money_type == 'bank' then
			if money_action == 'set' then
				xPlayer.setAccountMoney('bank', money_amount)
			elseif money_action == 'add' then
				xPlayer.addAccountMoney('bank', money_amount)
			elseif money_action == 'remove' then
				xPlayer.removeAccountMoney('bank', money_amount)
			end

		elseif money_type == 'black' then
			if money_action == 'set' then
				xPlayer.setAccountMoney('black_money', money_amount)
			elseif money_action == 'add' then
				xPlayer.addAccountMoney('black_money', money_amount)
			elseif money_action == 'remove' then
				xPlayer.removeAccountMoney('black_money', money_amount)
			end
		else
			if _source > 0 then
				TriggerClientEvent('chatMessage', _source, "SYSTEM", {255, 0, 0}, "^2" .. money_type .. " ^0 is not a valid money type!")
			end
			return
		end
	else
		if _source > 0 then
			TriggerClientEvent('chatMessage', _source, "SYSTEM", {255, 0, 0}, "Invalid arguments.")
		end
		return
	end

	local name = "server"
	if _source > 0 then
		name = GetPlayerName(_source)
	end
	print('admin_commands: ' .. name .. ' just ' .. money_action .. ' $' .. money_amount .. ' (' .. money_type .. ') to ' .. xPlayer.name)

	if _source > 0 then -- and xPlayer.source ~= _source then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('money_'..money_action, money_amount, money_type))
	end
end)

TriggerEvent('es:addGroupCommand', 'guitar', 'admin', function(source, args, user)
	TriggerClientEvent('admin_commands:guitar', source, args)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Играть на гитаре"})
