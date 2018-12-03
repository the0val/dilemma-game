local player, scene, font
local lg = love.graphics

function love.load()
	lg.setDefaultFilter("nearest", "nearest")
	player = require"player"
	scene = lg.newImage("scene.png")
	_G.sceneTranslation = 0

	font = lg.newFont("disposabledroid-bb.regular.ttf",30)
	lg.setFont(font)

	love.window.setTitle("Dilemmas")
end

function love.draw()
	
	-- Main screen
	lg.push()
	lg.scale(4, 4)

	lg.draw(scene, sceneTranslation % 200, 0)
	lg.draw(scene, (sceneTranslation % 200) - 200, 0)

	player.draw()
	lg.pop()


end

function love.update(dt)
	player.update(dt)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
