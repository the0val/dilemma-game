local simpleAnimate = {}

function simpleAnimate.newAnimation(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image
	animation.quads = {}
	animation.duration = duration
	animation.currentTime = 0

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width-1, height, image:getDimensions()))
		end
	end

	function animation:update(dt)
		self.currentTime = self.currentTime + dt
		if self.currentTime >= self.duration then
			self.currentTime = self.currentTime - self.duration
		end
	end

	return animation
end

return simpleAnimate
