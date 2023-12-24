--[[

Don't touch the code if you don't know what are you doing <3
____ ____ ____ ____ ____ ____ 
||c |||r |||i |||s |||k |||y ||
||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/__\|

Don't touch the code if you don't know what are you doing <3

--]]

AddCSLuaFile()

timer.Simple(1, function() -- initialize gamemode properly
	if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
		if SERVER then
			util.AddNetworkString("tttDeathNotify")
			hook.Add("PlayerDeath", "TTT_PlayerDeath_SayRole", function(victim, weapon, killer)
				if killer:IsPlayer() and killer ~= victim then
					net.Start("tttDeathNotify")
					net.WriteInt(1, 4)
					net.WriteString(killer:GetRoleString())
					net.WriteEntity(killer)
					net.Send(victim)
				elseif killer:IsPlayer() and killer == victim then
					net.Start("tttDeathNotify")
					net.WriteInt(2, 4)
					net.Send(victim)
				else
					net.Start("tttDeathNotify")
					net.WriteInt(3, 4)
					net.Send(victim)
				end
			end)
		else

			local defaultColor = Color(255, 255, 255)
			local prefixColor = Color(255, 255, 0)
			local prefix = "[TTT-Info] "

			net.Receive("tttDeathNotify", function()
				local killerType = net.ReadInt(4)
				local role = net.ReadString()
				local killer = net.ReadEntity()

				if role == "traitor" then
					role = "Traidor"
				end
				if role == "detective" then
					role = "Detective"
				end
				if role == "innocent" then
					role = "Inocente"
				end

				local roleColors = {
					["Traidor"] = Color(255, 0, 0),
					["Detective"] = Color(0, 0, 255),
					["Inocente"] = Color(0, 255, 0),
					["noround"] = Color(255, 255, 255)
				}

				if killerType == 1 then
					local killerColor = prefixColor -- string.sub used is required to override atlaschat name formatting.
					chat.AddText(prefixColor, prefix, defaultColor, "Fuiste asesinado por ", killerColor, string.sub(killer:GetName(), 1, 1), string.sub(killer:GetName(), 2, nil), defaultColor, " | Rol: ", roleColors[role], role, defaultColor, ".")
				elseif killerType == 2 then
					chat.AddText(prefixColor, prefix, defaultColor, "Te has suicidado.")
				elseif killerType == 3 then
					chat.AddText(prefixColor, prefix, defaultColor, "Fuiste asesinado por el mundo.")
				else
					chat.AddText(prefixColor, prefix, defaultColor, "Esto no debería mostrarse. Por favor contacta al creador para solucionar el problema.")
				end
			end)
		end
	end
end)

