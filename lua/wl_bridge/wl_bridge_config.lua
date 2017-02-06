--[[
############################################
#####Script made by: Aperture Hosting#######
##Script purpose: WoltLab Community Bridge#
##Other Info: WARNING! In future the config#
#####file will get Replaced with In-Game####
#######Configuration throught ULX (XGUI)####
############################################
]]--
WLBridge = WLBridge or {}
WLBridge.Config = WLBridge.Config or {}

--#######################
--#####MySQL Settings####
--#######################
WLBridge.Config.MySQL = {
	--The Database Server IP
	IP = "127.0.0.1",
	--The Database server Port
	Port = 3306,
	--The Database sheme Name
	Database = "",
	--The Database User
	Username = "root",
	--The database Users password
	Password = ""
}
--#############################
--##WoltLab Database Settings#
--#############################
WLBridge.Config.WoltLab = {
	--Your WL Version
	Version = "WSC3.0",
	--The Table with the User's and
	--the Profile Values
	UserTable = "wcf1_user_option_value",
	--The Columm with the SteamID
	UserTableSIDC = "",
	--The Group Table
	GroupTable = "wcf1_user_group",
	--The Connection Table from User to Group 
	UserToGroupTable = "wcf1_user_to_group",
	--If the script should use the steam OpenID plugin
	useOpenId = false
}
--###########################
--##Synchonisation Settings##
--###########################
WLBridge.Config.GroupToInGameRank = WLBridge.Config.GroupToInGameRank or {}
--To add a new Rank you need to write like this:
-- WLBridge.Config.GroupToInGameRank["WL Group"] = "In Game Rank"
--WARNING: WLGroup means the Database Group Name not
--the Actual WL Name. You can read them with
--MySQL Workbench or PhPMyAdmin in the GroupTable
WLBridge.Config.GroupToInGameRank["Administrator"] = "admin"
WLBridge.Config.GroupToInGameRank["wcf.acp.group.group4"] = "owner"	


--THE CONFIG ENDS HERE
include("wl_bridge/wl_bridge_main.lua")