local player = {}

player.count = 0
player.countInterval = 1 -- seconds
player.curTime = 0

function player.updateCount(dt)
	player.curTime = player.curTime + dt
	if player.curTime >= player.countInterval then
		player.curTime = player.curTime - player.countInterval
		player.count = player.count + 1
	end
end

function player.draw()
	love.graphics.print(player.count, 200, 200)
end

return player
