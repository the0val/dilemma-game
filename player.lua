local animation = require"animation"
local player = {x = 110, y = 110, isMoving = false, maxSpeed = 28}
local floor = math.floor
local sprite = love.graphics.newImage("Resources/player.png")
local tmpImage
player.tmpImageDuration = -1
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
	if love.keyboard.isDown("w", "up") then
		player.y = player.y - player.maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("s", "down") then
		player.y = player.y + player.maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("a", "left") then
		player.x = player.x - player.maxSpeed * dt * 1.5
		player.isMoving = true
	end
	if love.keyboard.isDown("d", "right") then
		player.x = player.x + player.maxSpeed * dt * 1.5
		player.isMoving = true
	end

	player.tmpImageDuration = player.tmpImageDuration - dt

	collide()
end

function player.draw()
	if player.tmpImageDuration > 0 then
		love.graphics.draw(tmpImage, floor(player.x + 0.5), floor(player.y + 0.5))
	else
		local spriteNum = player.isMoving and math.floor(player.motion.currentTime / player.motion.duration * #player.motion.quads) + 1 or 1
		love.graphics.draw(player.motion.spriteSheet, player.motion.quads[spriteNum], floor(player.x + 0.5), floor(player.y + 0.5))
	end
end

function player.getPos()
	return player.x - sceneTranslation, player.y
end

function player.changeImage(drawable, duration)
	tmpImage = drawable
	player.tmpImageDuration = duration
end

return player
