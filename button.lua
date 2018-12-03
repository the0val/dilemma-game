local button = {}

function button.new(buttonList, x, y, width, height, callback, args)
	buttonList = {}
	buttonList.x = x
	buttonList.y = y
	buttonList.width = width
	buttonList.height = height
	buttonList.callback = callback
	buttonList.args = args
end

function button.checkClick(buttonList, xPressed, yPressed)
	for _, v in pairs(button) do
		if xPressed >= v.x and xPressed <= v.x + v.width and
			yPressed >= v.y and yPressed <= v.y + v.height
		then
			v.callback(v.args)
		end
	end
end

return button
