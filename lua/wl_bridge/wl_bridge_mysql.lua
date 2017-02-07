WLBridge = WLBridge or {}
WLBridge.Config = WLBridge.Config or {}
local WLBridgeSQL = WLBridgeSQL or {}

function WLBridge.LoadPlayer(ply)
	WLBridgeSQL.ply = ply
	if (WLBridge.Config.WoltLab.useOpenId==true) then
		WLBridgeSQL.plySID = WLBridgeSQL.ply:SteamID64()
	else
		WLBridgeSQL.plySID = WLBridgeSQL.ply:SteamID()
	end
	local GetForumQ = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WoltLab.UserTable).."` WHERE `"..WLBridge.DB:escape(WLBridge.Config.WoltLab.UserTableSIDC).."`='"..WLBridge.DB:escape(WLBridgeSQL.plySID).."'")
	GetForumQ:start()
	GetForumQ:wait()
	GetForumQ.onSuccess = function() print("HAHA SUCCESS") end
	GetForumQ.onError = function(Q,E) print("Q1") print(E) end
	if GetForumQ:getData() ~= nil and GetForumQ:getData()[1] ~= nil then
		WLBridgeSQL.User = GetForumQ:getData()[1]
		WLBridge.LoadPlayerRank()
	end
end

function WLBridge.LoadPlayerRank()
	print("Running LoadPlayerRank")
	local GetRankIDQ = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WoltLab.UserToGroupTable).."` WHERE `userID`='"..WLBridgeSQL.User.userID.."'")
	GetRankIDQ:start()
	GetRankIDQ:wait()
	if GetRankIDQ:getData() ~= nil and GetRankIDQ:getData()[1] ~= nil then
		WLBridgeSQL.GroupID = GetRankIDQ:getData()
		WLBridge.RankPlayer()
	end
end

function WLBridge.RankPlayer()

	local WLBool = false
	
	WLBridgeSQL.PlayerGroups = WLBridgeSQL.PlayerGroups or {}
	for k,v in pairs(WLBridgeSQL.GroupID) do
		local GetPlyGroups = WLBridge.DB:query("SELECT * FROM `"..WLBridge.DB:escape(WLBridge.Config.WoltLab.GroupTable).."` WHERE `groupID`='"..v.groupID.."'")
		GetPlyGroups:start()
		GetPlyGroups:wait()
		if GetPlyGroups:getData() ~= nil and GetPlyGroups:getData()[1] ~= nil then
			WLBridgeSQL.PlayerGroups[k] = GetPlyGroups:getData()[1].groupName
		end
	end

	for k,v in pairs(WLBridgeSQL.PlayerGroups) do
		if WLBridge.Config.GroupToInGameRank[v] then
			if not(WLBridgeSQL.ply:IsUserGroup( WLBridge.Config.GroupToInGameRank[v] ))then
				RunConsoleCommand("ulx","adduserid",WLBridgeSQL.ply:SteamID(),WLBridge.Config.GroupToInGameRank[v])
				WLBool = true
			elseif(WLBridgeSQL.ply:IsUserGroup( WLBridge.Config.GroupToInGameRank[v] ))then
				WLBool = true
			end
		end
	end
	if((WLBool==false) and not(WLBridgeSQL.ply:IsUserGroup( "user" ))) then
		RunConsoleCommand("ulx","removeuserid",WLBridgeSQL.ply:SteamID())
	end
end