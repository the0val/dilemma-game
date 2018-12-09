local cutscene = {}
cutscene.active = false
local step = 1
local timer = 0 -- seconds

function cutscene.newScene(name, drawSteps, durations)
	cutscene[name] = {}
	if #drawSteps ~= #durations then
		error"number of steps not matching number of durations"
	end
	cutscene[name].drawSteps = drawSteps
	cutscene[name].durations = durations
end

function cutscene.activateScene(name)
	cutscene.active = name
	step = 1
end

function cutscene.draw()
	if cutscene.active then
		cur = cutscene[active]
		cur.drawSteps[step]()
	end
end

function cutscene.updateScene(dt)
	timer = timer + dt
	if cutscene.active then
		local cur = cutscene[active]
		if timer >= cur.durations[step] then
			timer = timer - cur.durations[step]
			step = step + 1
			if step > #cur.durations then
				cutscene.active = false
			end
		end
	end
end

return cutscene
