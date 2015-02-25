
ResourceManager = {}
Resources = {spritesheet={}}
local _path
local _collector


function newSource(row,col,sheet,...)
	local arg = {...}
	local tbl = {}
	tbl.rows = row or 1
	tbl.columns = col or 1
	if not sheet then
		tbl.spritesheet = false
		for i,v in ipairs(arg) do
			if type(v) == 'string' then
				table.insert(tbl, love.graphics.newImage(_path..v )) --one state
			elseif type(v) == 'table' then
				tbl[i] = {}
				for it,vi in ipairs(v) do
					table.insert(tbl[i], love.graphics.newImage(_path..vi)) --state broken into multiple graphics
				end
			end
		end
	else 
		tbl.spritesheet = sheet
		for i,v in ipairs(arg) do
			if type(v) == 'table' then
				if #v > 0 then
					tbl[i] = {}
					for it,vi in ipairs(v) do
						table.insert(tbl[i],love.graphics.newQuad( vi.x, vi.y, vi.width, vi.height))
					end
				else
					table.insert(tbl,love.graphics.newQuad( v.x, v.y, v.width, v.height)) --one state
				end
			end
		end
		
	end
	return tbl
	--image:typeOf("Drawable")
	
end


-- This function will return a string filetree of all files
-- in the folder and files in all subfolders
local function collect(folder, fileTree)
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
    for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        if lfs.isFile(file) then
            fileTree = fileTree.."\n"..file
        elseif lfs.isDirectory(file) then
            fileTree = fileTree.."\n"..file.." (DIR)"
            fileTree = collect(file, fileTree)
        end
    end
    return fileTree
end


function ResourceManager.load(path,sets)
	_path = path..'/'
	_collector = {}
	path_sets = sets
	print(collect(path,''))
end

function ResourceManager.addName(etype,name,row,col,...)
	local res = newSource(row,col,false,...)
	Resources[etype][name] = res
end

function ResourceManager.addSheet(sheet,...)
	
end

function ResourceManager.addType(etype,...)
	local arg = {...}
	local res
	if type(arg[1]) == 'table' then
		if arg[1].row and arg[1].col then
			res = newSource(arg[1].row,arg[1].col,false,...)
		else
			res = newSource(#arg[1],1,false,...)
		end
	else
		res = newSource(1,1,false,...)
	end
	Resources[etype] = Resources[etype] or {}
	Resources[etype].def = Resources[etype].def or res --add default
	table.insert(Resources[etype],res)
	return res
end


function ResourceManager.request(etype,var)
	
end
