local button = {}
local knownLists = {}
local selfRef = {}
local meta = {__index = selfRef}


function button.newButton(x, y, w, h, callback, args)
	local output = {}
	output.x = x
	output.y = y
	output.width = w
	output.height = h
	function output.callback()
		if args then
			callback(unpack(args))
		else
			callback()
		end
	end

	setmetatable(output, meta)

	return output
end

function button.initList(list, initEnabled)
	table.insert(knownLists, list)
	list.enabled = initEnabled
	return list
end

function selfRef:checkClick(xC, yC)
	if xC >= self.x and yC >= self.y and xC < self.x+self.width and yC < self.y+self.height then
		self.callback()
	end
end

function button.checkAll(xC, yC)
	for _, t in ipairs(knownLists) do
		if t.enabled then
			for __, v in ipairs(t) do
				v:checkClick(xC, yC)
			end
		end
	end
end

return button
