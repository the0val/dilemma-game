local character = require("player")

function love.draw()
	character.draw()
end

function love.update(dt)
	character.updateCount(dt)
end
