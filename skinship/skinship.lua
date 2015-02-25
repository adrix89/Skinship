

local path = (...):gsub('%.[^%.]+$', '') .. '.'

class = require(path .. 'middleclass')
--local patriachy = require(path .. 'stateful')	--It's like a hiearchy but better, cry feminists cry!
require(path .. 'elements')
require(path .. 'resource_manager')

skinship = {
  _VERSION     = 'skinship v0.9.0',
  _DESCRIPTION = [[
  	Skinship - Skinable Simple Hierarchical Interface Packer
  	Easy to use skinable GUI library for Love2D
  ]],
  
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2014 Borcea Victor Adrian

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

Hierarchy ={}		--Super Important! Global list of all elements


local function process(value)
	if (type(value)=="table") then
		if #value ~= 0 then
			coroutine.yield(value)
		end
		if value then
			for i,v in ipairs(value) do
				process(v)
			end
		end
	end
end

local function process2(value)
	if (type(value)=="table") then
		if value then
			for i,v in ipairs(value) do
				process(v)
			end
		end
		if #value ~= 0 then
			coroutine.yield(value)
		end
	end
end


local function Trav(root)		--Traverse through all element tree
   return coroutine.wrap(process),root
end

local function BackTrav(root)	--Back Traverse from the bottom of the tree to the top
   return coroutine.wrap(process2),root
end


function skinship.load()
	ResourceManager.load('skinship/skins')
	ResourceManager.addType('button',"UIpack_RPG/buttonLong_brown.png",
	"UIpack_RPG/buttonLong_brown_pressed.png")
	--tabs = Element:new("Tabs Panel")
	--tools = Element:new("Tools")
	b1 = Button:new("b")
	b2 = Element:new("a")
	b1.x = 400
	b1.y = 200
	---[[
	b2.x = 400
	b2.y = 200
	b2.width = 400
	b2.height = 300
	--]]
	
	for k,v in ipairs(Hierarchy) do
		print('v table='..tostring(v),type(v),v.etype,v:isInstanceOf(Element),v:isInstanceOf(Button))
		print('b1 eqaual to v= '..tostring(v==b1))
	end
	
end


function skinship.update(dt)
	b1:update(dt)
end

function skinship.draw(branch)
	if branch then
		branch:draw()
		for tbl in Trav(branch) do
			tbl:draw()
		end
	else
		for i, v in ipairs(Hierarchy) do
			v:draw()
			for tbl in Trav(v) do
				tbl:draw()
			end
		end
	end
	love.graphics.setColor(0, 120, 255, 255)
	love.graphics.print("button 1 x=".. b1.abs.x .." y="..b1.abs.y .." drawable=", 30, 75)
end

function skinship.mousepressed(x, y, button)
	for i, v in ipairs(Hierarchy) do
		if v:inBounds(x,y) then
			for tbl in BackTrav(v) do
				if tbl:inBounds(x,y) then
					tbl:click(x, y, button)
					tbl:_click(x, y, button)
					return
				end
			end
			v:click(x, y, button)
			v:_click(x, y, button)
		end	
	end
end


function skinship.mousereleased(x, y, button)
	for i, v in ipairs(Hierarchy) do
		if v:inBounds(x,y) then
			for tbl in BackTrav(v) do
				if tbl:inBounds(x,y) then
					tbl:clickRelease(x, y, button)
					return
				end
			end
			v:clickRelease(x, y, button)
		end	
	end
end

function skinship.keypressed(key, isrepeat)
	if key == "p" then
		b1:Click()
   end
	
end

function skinship.keyreleased(key)

	
end

function skinship.textinput(text)

	
end

