local player, scene, font, pedo, granny, choose, bubble, girl
local lg = love.graphics
local vanPos, hasPassedVan = 250, false
local cutscene, currentScene = false, ""
local menus = {}

local function displayChoice(texts)
	lg.draw(choose, 2, 20)
	lg.pop()
	for i = 1, 5 do
		lg.printf({{0, 0, 0, 1}, texts[i]}, 20, 6 + 21 * i * 4, 400)
	end
	lg.push()
	lg.scale(4, 4)
end

function love.load()
	lg.setDefaultFilter("nearest", "nearest")
	player = require"player"
	scene = lg.newImage("scene.png")
	_G.sceneTranslation = 0

	pedo = lg.newImage("pedovan.png")
	granny = lg.newImage("granny.png")
	choose = lg.newImage("choose.png")
	bubble = lg.newImage("speech.png")
	girl = lg.newImage("girl.png")

	font = lg.newFont("disposabledroid-bb.regular.ttf", 30)
	lg.setFont(font)
end

function love.draw()
	
	-- Main screen
	lg.push()
	lg.scale(4, 4)

	lg.draw(scene, sceneTranslation % 200, 0)
	lg.draw(scene, (sceneTranslation % 200) - 200, 0)

	-- Specials
	lg.draw(pedo, vanPos - 15 + sceneTranslation, 80)
	lg.draw(girl, vanPos + 38 + sceneTranslation, 82)

	if not cutscene then
		player.draw()
		lg.pop()
	else
		lg.pop()
		menus[currentScene].draw()
	end
	local pX, pY = player.getPos()
	lg.print(pX, 4, 4)
end

function love.update(dt)
	player.update(dt)
	local pX, pY = player.getPos()
	if (not hasPassedVan) and pX >= vanPos + 20 then
		cutscene = true
		currentScene = "van"
		player.maxSpeed = 0
	elseif hasPassedVan then
		player.maxSpeed = 18
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
