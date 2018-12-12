local player, animation, scene, font, pedo, granny, choose, bubble, girl, button, cutscene, kickAni, drug
local drugrun = false
local recX, recY = 0, 0 -- DEBUG
local lg = love.graphics
local hasPassed, vanPos, kickPos, drugPos, robberPos, trainPos, endPos = "none", 250, 400, 540, 620, 700, 740
local isCutscene, currentScene = false, ""
local kicking = "active"
local menus = {}
local killCount = 0
local glenn = false

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
	kickDead = lg.newImage("kickerdead.png")
	drug = lg.newImage("dealing.png")
	holdgun = lg.newImage("holdgun.png")
	holdphone = lg.newImage("holdphone.png")


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
			if s2 == 4 or (s1 == "kick" and s2 == 3) then player.changeImage(holdphone, 1) end
			if s1 == "train" then
				if s2 == 2 then killCount = killCount + 1
				else killCount = killCount + 3 end 
			elseif s2 == 5 then
				if s1 == "van" or s1 == "robber" then killCount = killCount + 1
				else killCount = killCount + 2 end
			end
			if s1 == "kick" and s2 == 3 then kicking = "stop" end
			if s2 == 5 then
				player.changeImage(holdgun, 1)
				if s1 == "van" then pedo = lg.newImage("shotdriver.png")
				elseif s1 == "kick" then kicking = "dead"
				elseif s1 == "drug" then drug = lg.newImage("dealdead.png")
				end --TODO tomorrow
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
			"Nothing", "Interfere with words", "Call police and do nothing", "Call police and interfere", "Shoot the guy",
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
			"Nothing", "Run past", "Ask for some", "Call police", "Shoot the guys",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"drug", 1}),
				button.newButton(8, 164, 300, 75, f, {"drug", 2}),
				button.newButton(8, 248, 300, 75, f, {"drug", 3}),
				button.newButton(8, 332, 300, 75, f, {"drug", 4}),
				button.newButton(8, 416, 300, 75, f, {"drug", 5})
			}
		}

		menus.robber = {draw = function()
				lg.push()
				lg.scale(4, 4)
				displayChoice("robber")
				player.draw()
				lg.pop()
			end,
			"Nothing", "Try to talk", "Save granny", "Call police", "Shoot him",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"robber", 1}),
				button.newButton(8, 164, 300, 75, f, {"robber", 2}),
				button.newButton(8, 248, 300, 75, f, {"robber", 3}),
				button.newButton(8, 332, 300, 75, f, {"robber", 4}),
				button.newButton(8, 416, 300, 75, f, {"robber", 5})
			}
		}

		menus.train = {draw = function()
				lg.push()
				lg.scale(4, 4)
				displayChoice("train")
				player.draw()
				lg.pop()
			end,
			"Nothing", "Pull the lever", "Run away", "Call the police", "Shoot the monitor",
			buttons = button.initList{
				button.newButton(8, 80, 300, 75, f, {"train", 1}),
				button.newButton(8, 164, 300, 75, f, {"train", 2}),
				button.newButton(8, 248, 300, 75, f, {"train", 3}),
				button.newButton(8, 332, 300, 75, f, {"train", 4}),
				button.newButton(8, 416, 300, 75, f, {"train", 5})
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
	
	if kicking == "dead" then
		lg.draw(kickDead, kickPos + sceneTranslation, 88)
	else
		local spriteNum
		if kicking == "active" then
			spriteNum = math.floor(kickAni.currentTime / kickAni.duration * #kickAni.quads) + 1
		elseif kicking == "stop" then
			spriteNum = 1 
		end
		love.graphics.draw(kickAni.spriteSheet, kickAni.quads[spriteNum], kickPos + sceneTranslation, 88)
	end

	lg.draw(drug, drugPos + sceneTranslation, 80)
	lg.draw(granny, robberPos + sceneTranslation + 5, 85)


	if not isCutscene then
		player.draw()
		lg.pop()
	else
		lg.pop()
		menus[currentScene].draw()
	end

	cutscene.draw()

	if hasPassed == "train" and pX >= endPos then
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

	-- DEBUG
	lg.print(recX, 800 - font:getWidth(tostring(recX)), 5)
	lg.print(recY, 800 - font:getWidth(tostring(recY)), 25)
	lg.print(tostring(glenn), 800 - font:getWidth(tostring(glenn)), 50)
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
	elseif hasPassed == "drug" and pX >= robberPos + 10 then
		isCutscene = true
		currentScene = "robber"
		menus.robber.buttons.enabled = true
		player.maxSpeed = 0
	else
		player.maxSpeed = 18
		if hasPassed == "drug" and drugrun then
			player.maxSpeed = 50
		end
	end
	if player.tmpImageDuration > 0 then
		player.maxSpeed = 0
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
	if xC >= 520 + sceneTranslation * 4 and yC >= 228 and xC <= 532 + sceneTranslation * 4 and yC <= 240 then
		glenn = true
	else
		glenn = false
	end
end
