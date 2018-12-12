local player, animation, scene, font, pedo, granny, choose, bubble, girl, button, cutscene, kickAni, drug
local drugrun = false
local recX, recY = 0, 0
local lg = love.graphics
local hasPassed, vanPos, kickPos, drugPos = "none", 250, 400, 540
local isCutscene, currentScene = false, ""
local menus = {}
local killCount = 0

function displayChoice(texts)
	lg.draw(choose, 2, 20)
	lg.pop()
	for i = 1, 5 do
		lg.printf({{0, 0, 0, 1}, menus[texts][i]}, 20, 6 + 21 * i * 4, 300)
	end
	lg.push()
	lg.scale(4, 4)
end

function love.load()
	lg.setDefaultFilter("nearest", "nearest")

	button = require"button"
	player = require"player"
	cutscene = require"cutscene"
	animation = require"animation"
	_G.sceneTranslation = 0

	scene = lg.newImage("scene.png")
	pedo = lg.newImage("pedovan.png")
	granny = lg.newImage("granny.png")
	choose = lg.newImage("choose.png")
	bubble = lg.newImage("speech.png")
	girl = lg.newImage("girl.png")
	kickAni = animation.newAnimation(lg.newImage("kick.png"), 15, 17, 0.3)
	drug = lg.newImage("dealing.png")


	-- load scenes
	do
		local function f(s1, s2)
			isCutscene = false
			currentScene = ""
			hasPassed = s1
			if s1 == "drug" and s2 == 2 then
				drugrun = true
			end
			menus[s1].buttons.enabled = false
			if s1 == "train" then
				if s2 == 2 then killCount = killCount + 1
				else killCount = killCount + 3 end 
			elseif s2 == 5 then
				if s1 == "van" or s1 == "robber" then killCount = killCount + 1
				else killCount = killCount + 2 end
			end

			-- cutscene.activateScene(s1 .. tostring(s2))
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
			"Nothing", "Confront the man", "Talk to the girl", "Call police", "Shoot the man",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"van", 1}),
				button.newButton(8, 164, 300, 75, f, {"van", 2}),
				button.newButton(8, 248, 300, 75, f, {"van", 3}),
				button.newButton(8, 332, 300, 75, f, {"van", 4}),
				button.newButton(8, 416, 300, 75, f, {"van", 5})
			}
		}

		menus.kick = {draw = function()
				lg.push()
				lg.scale(4, 4)
				displayChoice("kick")
				player.draw()
				lg.pop()
			end,
			"Nothing", "Call police and do nothing", "Call police and interfere", "Interfere with words", "Shoot the guy",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"kick", 1}),
				button.newButton(8, 164, 300, 75, f, {"kick", 2}),
				button.newButton(8, 248, 300, 75, f, {"kick", 3}),
				button.newButton(8, 332, 300, 75, f, {"kick", 4}),
				button.newButton(8, 416, 300, 75, f, {"kick", 5})
			}
		}

		menus.drug = {draw = function()
				lg.push()
				lg.scale(4, 4)
				displayChoice("drug")
				player.draw()
				lg.pop()
			end,
			"Nothing", "Run past", "Call police", "Ask for some", "Shoot the guys",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"drug", 1}),
				button.newButton(8, 164, 300, 75, f, {"drug", 2}),
				button.newButton(8, 248, 300, 75, f, {"drug", 3}),
				button.newButton(8, 332, 300, 75, f, {"drug", 4}),
				button.newButton(8, 416, 300, 75, f, {"drug", 5})
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
	local spriteNum = math.floor(kickAni.currentTime / kickAni.duration * #kickAni.quads) + 1
	love.graphics.draw(kickAni.spriteSheet, kickAni.quads[spriteNum], kickPos + sceneTranslation, 88)
	lg.draw(drug, drugPos + sceneTranslation, 80)


	if not isCutscene then
		player.draw()
		lg.pop()
	else
		lg.pop()
		menus[currentScene].draw()
	end

	cutscene.draw()

	if hasPassed == "train" then
		lg.clear(0, 0, 0, 1)
		lg.push()
		lg.scale(2, 2)
		lg.print("Game over", (400 - font:getWidth("Game over")) / 2, 95)
		lg.pop()
		local endText
		if killCount == 1 then
			endText = "You killed 1 person."
		else
			endText = "You killed "..killCount.." people."
		end
		lg.print(endText, (800 - font:getWidth(endText)) / 2, 270)
	end
end

function love.update(dt)
	kickAni:update(dt)
	player.update(dt)
	local pX, pY = player.getPos()
	if hasPassed == "none" and pX >= vanPos + 20 then
		isCutscene = true
		currentScene = "van"
		menus.van.buttons.enabled = true
		player.maxSpeed = 0
	elseif hasPassed == "van" and pX >= kickPos + 5 then
		isCutscene = true
		currentScene = "kick"
		menus.kick.buttons.enabled = true
		player.maxSpeed = 0
	elseif hasPassed == "kick" and pX >= drugPos + 5 then
		isCutscene = true
		currentScene = "drug"
		menus.drug.buttons.enabled = true
		player.maxSpeed = 0
	else
		player.maxSpeed = 18
		if hasPassed == "drug" and drugrun then
			player.maxSpeed = 50
		end
	end

	cutscene.updateScene(dt)
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
