
if(file.Exists( "bin/gmsv_mysqloo_linux.dll", "LUA" ) or file.Exists( "bin/gmsv_mysqloo_win32.dll", "LUA" ))then
	WLBridge = WLBridge or {}
	WLBridge.Config = WLBridge.Config or {}

	function WLBridge.Connect()
		require("mysqloo")
		WLBridge.DB = mysqloo.connect(WLBridge.Config.MySQL.IP, WLBridge.Config.MySQL.Username, WLBridge.Config.MySQL.Password, WLBridge.Config.MySQL.Database, WLBridge.Config.MySQL.Port)
		WLBridge.DB.onConnected = 	function() 
										print("[WLBridge] Connection Successfull") 
										include("wl_bridge/wl_bridge_mysql.lua")
										include("wl_bridge/wl_bridge_hooks.lua")
									end
		WLBridge.DB.onConnectionFailed = function() print("[WLBridge] Connection Error") end
		WLBridge.DB:connect()
	end

	
	WLBridge.Connect()
else
	print('[MSync] WARNING! You need MySQLoo v9 or higher for this addon to work!')
	print('[MSync] Get it from here: https://facepunch.com/showthread.php?t=1515853')
	print('[MSync] Here are installation instructions:')
	print('[MSync] https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql')
end