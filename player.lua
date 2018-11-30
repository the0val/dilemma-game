local animation = require"animation"
local player = {x = 30, y = 30}
local speedX, speedY = 0, 0
local maxspeed, acceleration = 4, 200
local floor = math.floor

player.motion = animation.newAnimation(love.graphics.newImage("player.png"), 10, 20, 0.4)

function player.update(dt)
	player.motion.currentTime = player.motion.currentTime + dt
	if player.motion.currentTime >= player.motion.duration then
		player.motion.currentTime = player.motion.currentTime - player.motion.duration
	end
	
	if love.keyboard.isDown("w") then
		speedY = (speedY > -maxspeed) and speedY - 200 * dt or -maxspeed
	end
	if love.keyboard.isDown("s") then
		speedY = (speedY < maxspeed) and speedY + 200 * dt or maxspeed
	end
	if love.keyboard.isDown("a") then
		speedX = (speedX > -maxspeed) and speedX - 200 * dt or -maxspeed
	end
	if love.keyboard.isDown("d") then
		speedX = (speedX < maxspeed) and speedX + 200 * dt or maxspeed
	end
	speedX, speedX = speedX * 0.00001 * dt, speedY * 0.00001 * dt

	player.x, player.y = player.x + speedX * dt, player.y + speedY * dt
end

function player.draw()
	local spriteNum = math.floor(player.motion.currentTime / player.motion.duration * #player.motion.quads) + 1
	love.graphics.draw(player.motion.spriteSheet, player.motion.quads[spriteNum], floor(player.x + 0.5), floor(player.y + 0.5), 0)
end

return player
