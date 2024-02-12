local welcome = [=[|cffeeee22Dungeon Makerel loaded!
Type "/dungeonmode" or "/dng" to toggle dungeon mode!
Or type "/dng on" or "/dng off" to set dungeon mode on/off.
In Dungeon Mode, right click will work ONLY on enemies.
]=]
--local welcome_msg = string.gsub(welcome,"\92n", "\n") --Subbing out my text editor's new line escape for the \n recognized by WoW.. i think
print(welcome)

local default_settings = {
	strict = true, --currently always true. Exists for future LeftButton integration
	on = false
}

--DngMode_flags loaded from toc file

if DngMode_flags == nil then
	DngMode_flags = default_settings --Load default settings if none saved
end
DngMode_flags.on = false 			 --Always start game with Dungeon Mode off

msg_dng_on  = "|cffeeee22DUNGEON MODE ON - Right-click in combat can target ONLY ENEMIES"
msg_dng_off = "|cffeeee22DUNGEON MODE OFF - Right-click in combat has FULL FUNCTIONALITY"

function setMode(msg)
	if msg == "on" or msg == "1" then
		DngMode_flags.on = true
	elseif msg =="off" or msg == "0" then
		DngMode_flags.on = false 
	elseif msg == "" then
		DngMode_flags.on = not DngMode_flags.on
	end
	if DngMode_flags.on then print(msg_dng_on) else print(msg_dng_off) end

end

function untarget(self,button)
	if button == "RightButton" and DngMode_flags.on then
		local result,_ = SecureCmdOptionParse("[@mouseover,dead][@mouseover,help]cancel;[@mouseover,harm]keep;[@mouseover,noexists]discard")
		if result == "cancel" and UnitAffectingCombat("player") then
			MouselookStop()
		elseif DngMode_flags.strict then
			if result == "discard" and UnitAffectingCombat("player") then
				MouselookStop()
			end
		end
	end
end


--slash commands
SLASH_DUNGEONMODE1 = "/dungeonmode"
SLASH_DUNGEONMODE2 = "/dng"
SlashCmdList["DUNGEONMODE"] = function(msg) setMode(msg) end

--Meat
WorldFrame:HookScript("OnMouseUp",untarget)

--Initializer
loaderFrame = CreateFrame("Frame")
--loaderFrame:RegisterEvent("ADDON_LOADED")
loaderFrame:RegisterEvent("PLAYER_LOGIN")
loaderFrame:SetScript("OnEvent",loader)




