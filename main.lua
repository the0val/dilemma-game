local player, scene, font, pedo, granny, choose, bubble, girl
local recX, recY = 0, 0
local lg = love.graphics
local vanPos, hasPassedVan = 250, false
local isCutscene, currentScene = false, ""
local menus = {}

function displayChoice(texts)
	lg.draw(choose, 2, 20)
	lg.pop()
	for i = 1, 5 do
		lg.printf({{0, 0, 0, 1}, menus[texts][i]}, 20, 6 + 21 * i * 4, 400)
	end
	lg.push()
	lg.scale(4, 4)
end

function love.load()
	lg.setDefaultFilter("nearest", "nearest")

	button = require"button"
	player = require"player"
	_G.sceneTranslation = 0

	scene = lg.newImage("scene.png")
	pedo = lg.newImage("pedovan.png")
	granny = lg.newImage("granny.png")
	choose = lg.newImage("choose.png")
	bubble = lg.newImage("speech.png")
	girl = lg.newImage("girl.png")

	-- load scenes
	do
		local function f(s)
			isCutscene = false
			currentScene = ""
			hasPassedVan = true
			-- cutscene.activateScene("van" .. tostring(s))
		end
		
		menus.van = {draw = function()
				lg.push()
				lg.scale(4, 4)
				lg.draw(bubble, vanPos + sceneTranslation, 58)
				displayChoice("van")
				player.draw()
				lg.pop()
				lg.printf({{0, 0, 0, 1},"Come here little girl!"}, (vanPos + sceneTranslation) * 4 + 20, 60 * 4, 150)
			end,
			"Keep walking", "Confront the man", "Talk to the girl", "Call police", "Pull out gun",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {1}),
				button.newButton(8, 164, 300, 75, f, {2}),
				button.newButton(8, 248, 300, 75, f, {3}),
				button.newButton(8, 332, 300, 75, f, {4})
			}
		}
	end

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

	if not isCutscene then
		player.draw()
		lg.pop()
	else
		lg.pop()
		menus[currentScene].draw()
	end

	cutscene.draw()

	lg.print(recX, 4, 4)
	lg.print(recY, 4, 22)
end

function love.update(dt)
	player.update(dt)
	local pX, pY = player.getPos()
	if (not hasPassedVan) and pX >= vanPos + 20 then
		isCutscene = true
		currentScene = "van"
		menus.van.buttons.enabled = true
		player.maxSpeed = 0
	else
		player.maxSpeed = 18
	end

	cutscene.update()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "t" then
		debug.debug()
	end
end

function love.mousepressed(xC, yC, b)
	recX, recY = xC, yC
	if b == 1 then
		button.checkAll(xC, yC)
	end
end
