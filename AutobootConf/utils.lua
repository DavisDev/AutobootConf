--[[ 
	More utils functions.
	Functions more used for any project.
	
	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Designed By DevDavisNunez.
]]

function files.write(path,data,mode) -- Write a file.
	local fp = io.open(path, mode or "w+");
	if fp == nil then return end
	fp:write(data);
	fp:flush();
	fp:close();
end

function files.read(path,mode) -- Read a file.
	local fp = io.open(path, mode or "r")
	if not fp then return nil end
	local data = fp:read("*a")
	fp:close()
	return data
end

function newScroll(a,b,c)
	local obj = {ini=1,sel=1,lim=1,maxim=1,minim = 1}
	function obj:set(tab,mxn,modemintomin) -- Set a obj scroll
		obj.ini,obj.sel,obj.lim,obj.maxim,obj.minim = 1,1,1,1,1
		if(type(tab)=="number")then
			if tab > mxn then obj.lim=mxn else obj.lim=tab end
			obj.maxim = tab
		else
			if #tab > mxn then obj.lim=mxn else obj.lim=#tab end
			obj.maxim = #tab
		end
		if modemintomin then obj.minim = obj.lim end
	end
	function obj:max(mx)
		obj.maxim = #mx
	end
	function obj:up()
		if obj.sel>obj.ini then obj.sel=obj.sel-1
		elseif obj.ini-1>=obj.minim then
			obj.ini,obj.sel,obj.lim=obj.ini-1,obj.sel-1,obj.lim-1
		end
	end
	function obj:down()
		if obj.sel<obj.lim then obj.sel=obj.sel+1
		elseif obj.lim+1<=obj.maxim then
			obj.ini,obj.sel,obj.lim=obj.ini+1,obj.sel+1,obj.lim+1
		end
	end
	function obj:test(x,y,h,tabla,high,low,size)
		local py = y
		for i=obj.ini,obj.lim do 
			if i==obj.sel then screen.print(x,py,tabla[i],size,high)
			else screen.print(x,py,tabla[i],size,low)
			end
			py += h
		end
	end
	if a and b then
		obj:set(a,b,c)
	end
	return obj
end