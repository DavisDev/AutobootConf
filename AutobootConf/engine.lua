local version = files.read("ux0:/data/AutoBoot/version")

if not version or tonumber(version) < APP_VERSION then -- Have old version installed, update! ;)
	files.write("ux0:/data/AutoBoot/version", APP_VERSION)
	files.copy("plugin/boot.cfg","ux0:/data/AutoBoot/")
	files.copy("plugin/AutoBoot.suprx","ux0:/tai/")
end

local BootID,BootTitle,BootIcon = files.read("ux0:/data/AutoBoot/boot.cfg") or "MLCL00001","", nil

plugin = {prxline = 0, mainln = 0}

function plugin.check()
	local path = "ux0:tai/config.txt"
	plugin.cfg = {} -- Set to Zero
	plugin.state = false
	if files.exists(path) then -- Only read if exists LOL xD
		local main_sect = false
		local i = 1;
		for line in io.lines(path) do
			table.insert(plugin.cfg,line)
			
			if main_sect then
				if line:gsub('#',''):lower() == "ux0:tai/autoboot.suprx" then
					plugin.state = true;
					plugin.prxline = i
				end
			end
			
			if line:find("*",1) then -- Secction Found
				if line:sub(2) == "main" and not plugin.state then
					main_sect = true;
					plugin.mainln = i;
				else
					main_sect = false;
				end
			end
			
			i += 1
		end
	end
end

function plugin.set(state)
	if state and not plugin.state then
		if plugin.mainln != 0 then
			table.insert(plugin.cfg, plugin.mainln+1, "ux0:tai/autoboot.suprx")
		else
			table.insert(plugin.cfg, "*main")
			table.insert(plugin.cfg, "ux0:tai/autoboot.suprx")
		end
		files.write("ux0:tai/config.txt", table.concat(plugin.cfg, '\n'))
		plugin.state = true
	end
	if not state and plugin.state then
		table.remove(plugin.cfg, plugin.prxline)
		--if not plugin.cfg[plugin.prxline]:sub(1,4) == "ux0:" then -- no have another prx in the secction...
			--table.remove(plugin.cfg, plugin.mainln)
		--end
		files.write("ux0:tai/config.txt", table.concat(plugin.cfg, '\n'))
		plugin.state = false
	end
end

plugin.check()

stars.init(color.white)
local back = image.load("sce_sys/livearea/contents/bg0.png")

local list = game.list()
--table.sort(list ,function (a,b) return string.lower(a.id)<string.lower(b.id); end)

for i=1, #list do
	local info = nil
	list[i].type = 0
	if list[i].path:sub(1,10) == "ux0:pspemu" then
		info = game.info(string.format("%s/eboot.pbp",list[i].path))
		list[i].icon = game.geticon0(string.format("%s/eboot.pbp",list[i].path))
		list[i].type = 1
	else
		info = game.info(string.format("%s/sce_sys/param.sfo",list[i].path))
		list[i].icon = image.load(string.format("%s/sce_sys/icon0.png",list[i].path))
	end
	list[i].title = list[i].id --the param.sfo on some apps are unreadable
	list[i].cat = "---"
	if info and info.TITLE then list[i].title = info.TITLE end
	if info and info.CATEGORY then list[i].cat = info.CATEGORY end
	if list[i].id == BootID then BootIcon, BootTitle = list[i].icon, list[i].title end
end

table.sort(list ,function (a,b) return string.lower(a.title)<string.lower(b.title); end)

local scroll = newScroll(list, 18)

buttons.interval(10,10)
while true do
	buttons.read()
	if buttons.up or buttons.analogly < -60 then scroll:up() elseif buttons.down or buttons.analogly > 60 then scroll:down() end
	if buttons.cross then
		BootID = list[scroll.sel].id
		files.write("ux0:/data/AutoBoot/boot.cfg", BootID)
	end
	if buttons.r then
		plugin.set(true)
	elseif buttons.l then
		plugin.set(false)
	end
	if back then back:blit(0,0) end
	stars.render()
	draw.fillrect(0,0,960,25,color.shadow)
	screen.print(10,5,string.format("Autoboot Configurator %X.%02X",APP_VERSION_MAJOR, APP_VERSION_MINOR),1,color.white)
	screen.print(950,5,string.format("%s - Batt: %s%%", os.date("%I:%M %p"), batt.lifepercent()),1,color.white,0x0,__ARIGHT) --FPS: %d - , screen.fps()
	local y = 35
	for i=scroll.ini, scroll.lim do
		if i == scroll.sel then draw.fillrect(0,y,960,20,color.shadow) end
		if list[i].id == BootID then BootIcon, BootTitle = list[i].icon, list[i].title end
		screen.print(10,y, list[i].title, 1, color.white)
		y += 20
	end
	--[[
	-- Load in running? :)
	if not list[scroll.sel].icon and not list[scroll.sel].try then
		list[scroll.sel].try = true
		if list[scroll.sel].type == 0 then
			list[scroll.sel].icon = image.load(string.format("%s/sce_sys/icon0.png",list[scroll.sel].path))
		else
			list[scroll.sel].icon = game.geticon0(string.format("%s/eboot.pbp",list[scroll.sel].path))
		end
	end]]
	if list[scroll.sel].icon then
		if list[scroll.sel].type == 0 then screen.clip(950-64, 235, 128/2) end
		list[scroll.sel].icon:center()
		list[scroll.sel].icon:blit(950-128 + 64, 235)
		screen.clip()
	else
		draw.fillrect(950-128,235-64, 128, 128, color.white:a(100))
		draw.rect(950-128,235-64, 128, 128, color.white)
	end
	
	screen.print(10,435,"Actual Config:")
	local posx = 10+screen.textwidth("Actual Config: ")
	local text,col = "Disabled", color.red
	if plugin.state then
		text,col = "Enabled", color.green
	end
	screen.print(posx,435,text, 1, col)
	screen.print(10,455,BootTitle)
	screen.print(10,475,BootID)
	if BootIcon then
		screen.clip(950-64, 540-64, 128/2)
		BootIcon:center()
		BootIcon:blit(950-128 + 64, 540-64)
		screen.clip()
	end
	screen.flip()
end