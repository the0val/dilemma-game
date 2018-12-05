return {draw = function()
		lg.push()
		lg.scale(4, 4)
		lg.draw(bubble, vanPos + sceneTranslation, 58)
		displayChoice(menus.van)
		player.draw()
		lg.pop()
		lg.printf({{0, 0, 0, 1},"Come here little girl!"}, (vanPos + sceneTranslation) * 4 + 20, 60 * 4, 150)
	end,
	"Keep walking", "Confront the man", "Talk to the girl", "Call police", "Pull out gun",
	buttons = {}
}
