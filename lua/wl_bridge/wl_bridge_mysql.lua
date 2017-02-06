WLBridge = WLBridge or {}
WLBridge.Config = WLBridge.Config or {}
local WLBridgeSQL = WLBridgeSQL or {}

function WLBridge.LoadPlayer(ply)
	print("Running LoadPlayer")
	WLBridgeSQL.ply = ply
	print(ply:SteamID())
	print(WLBridgeSQL.ply:SteamID())
	local GetForumQ = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WorldLab.UserTable).."` WHERE `"..WLBridge.DB:escape(WLBridge.Config.WorldLab.UserTableSIDC).."`='"..WLBridge.DB:escape(WLBridgeSQL.ply:SteamID()).."'")
	GetForumQ:start()
	GetForumQ:wait()
	GetForumQ.onSuccess = function() print("HAHA SUCCESS") end
	GetForumQ.onError = function(Q,E) print("Q1") print(E) end
	if GetForumQ:getData() ~= nil and GetForumQ:getData()[1] ~= nil then
		WLBridgeSQL.User = GetForumQ:getData()[1]
		WLBridge.LoadPlayerRank()
		print("Returned")
	end
end

function WLBridge.LoadPlayerRank()
	print("Running LoadPlayerRank")
	local GetRankIDQ = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WorldLab.UserToGroupTable).."` WHERE `userID`='"..WLBridge.DB:escape(WLBridgeSQL.User.userID).."'")
	GetRankIDQ:start()
	GetRankIDQ:wait()
	if GetRankIDQ:getData() ~= nil and GetRankIDQ:getData()[1] ~= nil then
		WLBridgeSQL.GroupID = GetRankIDQ:getData()
		WLBridge.RankPlayer()
		print("Returned")
	end
end

function WLBridge.RankPlayer()
	print("Running RankPlayer")
	local WLBool = false
	WLBridgeSQL.PlayerGroups = WLBridgeSQL.PlayerGroups or {}
	for k,v in pairs(WLBridgeSQL.GroupID) do
		local GetPlyGroups = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WorldLab.GroupTable).."` WHERE `groupID`='"..WLBridge.DB:escape(v.groupID).."'")
		GetPlyGroups:start()
		GetPlyGroups:wait()
		if GetPlyGroups:getData() ~= nil and GetPlyGroups:getData()[1] ~= nil then
			WLBridgeSQL.PlayerGroups[k] = GetPlyGroups:getData()[1].groupName
		end
	end
	PrintTable(WLBridge.Config.GroupToInGameRank)
	for k,v in pairs(WLBridgeSQL.PlayerGroups) do
		if WLBridge.Config.GroupToInGameRank[v] then
			if not(WLBridgeSQL.ply:IsUserGroup( WLBridge.Config.GroupToInGameRank[v] ))then
				RunConsoleCommand("ulx","adduserid",WLBridgeSQL.ply:SteamID(),WLBridge.Config.GroupToInGameRank[v])
				WLBool = true
			end
		end
	end
	if(WLBool==false) and not(WLBridgeSQL.ply:IsUserGroup( "user" )) then
		RunConsoleCommand("ulx","removeuserid",WLBridgeSQL.ply:SteamID())
	end
end