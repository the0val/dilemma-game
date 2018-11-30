local animation = require"animation"
local player = {x = 30, y = 30, isMoving = false}
local maxSpeed = 18
local floor = math.floor

player.motion = animation.newAnimation(love.graphics.newImage("player.png"), 10, 20, 0.4)

function player.update(dt)
	player.motion.currentTime = player.motion.currentTime + dt
	if player.motion.currentTime >= player.motion.duration then
		player.motion.currentTime = player.motion.currentTime - player.motion.duration
	end
	
	player.isMoving = false
	if love.keyboard.isDown("w") then
		player.y = player.y - maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("s") then
		player.y = player.y + maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - maxSpeed * dt
		player.isMoving = true
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + maxSpeed * dt
		player.isMoving = true
	end
end

function player.draw()
	local spriteNum = player.isMoving and math.floor(player.motion.currentTime / player.motion.duration * #player.motion.quads) + 1 or 1
	love.graphics.draw(player.motion.spriteSheet, player.motion.quads[spriteNum], floor(player.x + 0.5), floor(player.y + 0.5))
end

return player
