local animation = require"animation"
local player = {x = 110, y = 110, isMoving = false, maxSpeed = 28}
local floor = math.floor
local sprite = love.graphics.newImage("player.png")
player.motion = animation.newAnimation(sprite, 10, 20, 0.4)

local function collide()
	player.y = player.y <= 150 - sprite:getHeight() and player.y or 150 - sprite:getHeight()
	player.y = player.y >= 87 and player.y or 87
	
	
	if player.x > 195 - sprite:getWidth() then
		sceneTranslation = sceneTranslation - (player.x - (195 - sprite:getWidth()))
		player.x = 195 - sprite:getWidth()
	else
		if player.x < 5 then
			sceneTranslation = sceneTranslation + (5 - player.x)
			player.x = 5
		end
	end
	
end

function player.update(dt)
	player.motion.currentTime = player.motion.currentTime + dt
	if player.motion.currentTime >= player.motion.duration then
		player.motion.currentTime = player.motion.currentTime - player.motion.duration
	end
	
	player.isMoving = false
	if love.keyboard.isDown("w") then
		player.y = player.y - player.maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("s") then
		player.y = player.y + player.maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - player.maxSpeed * dt * 1.5
		player.isMoving = true
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + player.maxSpeed * dt * 1.5
		player.isMoving = true
	end

	collide()
end

function player.draw()
	local spriteNum = player.isMoving and math.floor(player.motion.currentTime / player.motion.duration * #player.motion.quads) + 1 or 1
	love.graphics.draw(player.motion.spriteSheet, player.motion.quads[spriteNum], floor(player.x + 0.5), floor(player.y + 0.5))
end

function player.getPos()
	return player.x - sceneTranslation, player.y
end

return player
