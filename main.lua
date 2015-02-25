require("skinship.skinship")

function love.load()
	
	skinship.load()
end

function love.update(dt)

	skinship.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor( 180,180,200 )	
	skinship.draw()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
	skinship.keypressed(key, isrepeat)
end

function love.mousepressed(x, y, button)
	skinship.mousepressed(x, y, button)
end

function love.resize(w, h)
	
end
