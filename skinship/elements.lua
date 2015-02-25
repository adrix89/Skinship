--[[
	Elements

]]--

--local class = require(path .. 'middleclass')
--require(path .. 'skinship')

Element = class('Element')
Control = class('Control')

function Element:initialize(name,res,parent)	
	self.name = name or 'Element'
	self.etype = 'element'
	self.tooltip = ""
	self.text = "What a lame example"		--named data
	self.resource = res or Resources[self.etype] and Resources[self.etype].def
	self.drawable = false
	self.control = false 	--primary control that extends behaviour, rest is in children
	self.active = false		--element is animated
	self.transparent = false		--element has visible 
	self.disable = false	--disable element and all its children
	self.selected = false 	--current selection from children, tabs branch
	if parent then
		self.parent = parent
		table.insert(parent,self)
		self.order = #parent  --lower is more important
	else
		table.insert(Hierarchy,self)
		self.order = #Hierarchy
	end
	self.state = 1			--add named states? constants?
	self.data = false		--primary data, check for type?
	self.area = {x=0,y=0,width=0,height=0}
	self.width = 100
	self.height = 50
	self.x = 0	--relative x,y, top is absolute
	self.y = 0
	self.anchor = {0,0} --from what direction it draws 0,0 top left 1,1 bottom right 0.5,0.5 middle
	self.abs= {}
	self.abs.x = 0
	self.abs.y = 0
	self.color = {0,0,0,255} --text black
	self.background = {0, 80, 220, 140} --text black, maybe texture?
	print('self='..tostring(self))
end

function Control:initialize(parent)	
	self.master = false
	self.disable = false
	self.x = 0	--relative x,y, top is absolute
	self.y = 0
	self.anchor = {0,0} --from what direction it draws 0,0 top left 1,1 bottom right 0.5,0.5 middle
	self.abs= {}
	self.abs.x = 0
	self.abs.y = 0
	if parent then
		self.parent = parent
		table.insert(parent,self)
		self.order = #parent  --lower is more important
	else
		table.insert(Hierarchy,self)
		self.order = #Hierarchy
	end
	
end

local function setHierarchy()
	

end

function Element:draw()
	if not self.drawable then
		love.graphics.setColor(unpack(self.background))
		love.graphics.rectangle( 'fill',self.x, self.y, self.width, self.height )
		love.graphics.setColor(unpack(self.color))
		love.graphics.print(self.text, self.x, self.y)
	elseif self.drawable:typeOf("Drawable") then
		love.graphics.draw( self.drawable, self.x, self.y)
	else
		if self.drawable.spritesheet then
			local wide =0
			local high =0
			for j=1,self.drawable.columns do
				for i=1,self.drawable.rows do 
					love.graphics.draw(self.drawable.spritesheet, self.drawable[i+j-1], self.x+wide, self.y+high)
					wide = self.drawable[i+j-1]:getWidth()
				end
				wide=0
				height = self.drawable[i+j-1]:getHeight()
			end
		else
			local wide =0
			local high =0
			for j=1,self.drawable.columns do
				for i=1,self.drawable.rows do 
					love.graphics.draw( self.drawable[i+j-1], self.x+wide, self.y+high)
					wide = self.drawable[i+j-1]:getWidth()
				end
				wide=0
				height = self.drawable[i+j-1]:getHeight()
			end
		end
	end
end

function Element:update(dt)
	if parent then
		self.abs.x = parent.abs.x + self.x
		self.abs.y = parent.abs.y + self.y
	else
		self.abs.x = self.x
		self.abs.y = self.y
	end
end

function Element:createChild(parent,...)

end

function Element:selected(element)
	if self.parent then
		return self.parent:selected(element)
	end
end

function Element:modify(stuff)
	self.data = stuff
end

function Element:click(x, y, button)
	self:selected(self)
end

function Element:_click(x, y, button)
	
end

function Element:clickRelease(x, y, button)
	
end

function Element:keyDown(x, y, button)
	
end

function Element:keyRelease(x, y, button)
	
end

function Element:Hover()

end

function Element:inBounds(x,y)
	print("X = "..x.." Y = "..y)
	if x >= self.abs.x and x <= self.abs.x + self.width then
		if y >= self.abs.y and y <= self.abs.y + self.height then
			return true
		end
	end
	return false
end


Button = class('Button', Element)

function Button:initialize(name,...)
	Element.initialize(self, name,...)
	self.name = name or 'Button'..self.order
	self.etype = 'button'
	self.resource = res or Resources['button'].def
	self.drawable = self.resource[1]
	self.width,self.height = self.drawable:getDimensions()
	--print('intialized button self='..tostring(self).." etype="..self.etype)
end

function Button:_click()
	local diffX = self.resource[1]:getWidth() - self.resource[2]:getWidth()
	local diffY = self.resource[1]:getHeight() - self.resource[2]:getHeight()
	if self.data then
		self.drawable = self.resource[2]
		self.x = self.x +diffX
		self.y = self.y +diffY
	else
		self.drawable = self.resource[1]
		self.x = self.x -diffX
		self.y = self.y -diffY
	end
	self.width,self.height = self.drawable:getDimensions()
end

function Button:click()		--toggle
	self.data = not self.data
end
