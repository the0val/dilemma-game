local player = require("player")
local scene, backgroundCanvas, playerCanvas
local font

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(800, 600, {})
	scene = love.graphics.newImage("scene.png")
	backgroundCanvas = love.graphics.newCanvas(200, 150)

	font = love.graphics.newFont("disposabledroid-bb.regular.ttf",30)
	love.graphics.setFont(font)
end

function love.draw()
	love.graphics.setCanvas(backgroundCanvas)
	love.graphics.draw(scene, 0, 0)
	player.draw()
	love.graphics.setCanvas()
	love.graphics.draw(backgroundCanvas, 0, 0, 0, 4, 4)

	love.graphics.print("Hello World!",10,10)
end

function love.update(dt)
	player.update(dt)
end
