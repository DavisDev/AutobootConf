--[[ 
	Particles FX library.
	Draw a shower of particles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- DevDavisNunez (https://twitter.com/DevDavisNunez).
	
]]

stars = {math={}} -- module stars! :D

function stars.init(c)
	math.randomseed(os.clock())
	--stars.obj = image.new(3,3,c or color.new(255,255,255))
	stars.color = c or color.new(255,255,255)
	for i=1,200 do
		stars.math[i] = {x=math.random(960,960+480), y=math.random(0,544),s=(math.random(0,4)+math.random(0,2)), a=math.random(0,255)}
	end
end

function stars.render()
	for i=1,200 do
		stars.math[i].x=stars.math[i].x-stars.math[i].s
		stars.math[i].a=stars.math[i].a-1
		if stars.math[i].x<=0 then
			stars.math[i].x=960
			stars.math[i].y=math.random(0,544)
		end
		if stars.math[i].a<=0 then
			stars.math[i].a=255
		end
		--stars.obj:blit(stars.math[i].x, stars.math[i].y,stars.math[i].a)
		draw.circle(stars.math[i].x, stars.math[i].y, 3, stars.color:a(stars.math[i].a))
	end
end