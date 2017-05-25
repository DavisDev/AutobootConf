--[[ 
	Autoboot Configurator.
	Configurator & installer of the plugin 'Autoboot' of Rinnegatamante.
	
	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltaR4.
]]

color.loadpalette() -- Load all colors!
files.mkdir("ux0:/data/AutoBoot/") -- Create a work folder :)

-- Constants
APP_VERSION_MAJOR = 0x01 -- major.minor
APP_VERSION_MINOR = 0x00
	
APP_VERSION = ((APP_VERSION_MAJOR << 0x18) | (APP_VERSION_MINOR << 0x10)) -- Union Binary

-- == Updater ==
if files.exists("ux0:/app/ABUPDATER") then
	game.delete("ABUPDATER") -- Exists delete update app
end

files.mkdir("ux0:/data/1luapkg")

function onAppInstallCB(step, size_argv, written, file, totalsize, totalwritten)
	return 10 -- Ok code
end

function onNetGetFileCB(size,written,speed)
	screen.print(10,10,"Downloading Update...")
	screen.print(10,30,"Size: "..tostring(size).." Written: "..tostring(written).." Speed: "..tostring(speed).."Kb/s")
	screen.print(10,50,"Porcent: "..math.floor((written*100)/size).."%")
	draw.fillrect(0,520,((written*960)/size),24,color.new(0,255,0))
	screen.flip()
	buttons.read()
	if buttons.circle then	return 0 end --Cancel or Abort
	return 1;
end

local version = http.get("https://raw.githubusercontent.com/DavisDev/AutobootConf/master/version")
if version and tonumber(version) then
	version = tonumber(version)
	local major = (version >> 0x18) & 0xFF;
	local minor = (version >> 0x10) & 0xFF;
	if version > APP_VERSION then
		local res = os.message("Autoboot Configurator "..string.format("%X.%02X",major, minor).." is now available.\n".."Do you want to update the application?", 1)
		if res == 1 then -- Response Ok.
			buttons.homepopup(0)
			local url = string.format("https://github.com/DavisDev/AutobootConf/releases/download/%s/AutobootConf.vpk", string.format("%X.%02X",major, minor))
			local path = "ux0:/data/AutoBoot/AutobootConf.vpk"
			--os.message(url:sub(1,#url/2).."\n"..url:sub(#url/2))
			onAppInstall = onAppInstallCB
			onNetGetFile = onNetGetFileCB
			local res = http.getfile(url, path)
			if res then -- Success!
				files.copy("eboot.bin","ux0:/data/1luapkg")
				files.copy("updater/script.lua","ux0:/data/1luapkg/")
				files.copy("updater/param.sfo","ux0:/data/1luapkg/sce_sys/")
				game.installdir("ux0:/data/1luapkg")
				files.delete("ux0:/data/1luapkg")
				game.launch("ABUPDATER") -- Goto installer extern!
			end
			buttons.homepopup(1)
		end
	end
end

dofile("utils.lua") -- Library Functions.
dofile("stars.lua") -- Library FX
dofile("engine.lua") -- Main Code!