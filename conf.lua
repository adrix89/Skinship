function love.conf(t)
    t.title = "Skinship"   -- The title of the window the game is in (string)
    t.author = "Victor Adrian Borcea" -- The author of the game (string)
    t.url = nil                 -- The website of the game (string)
    t.identity = nil            -- The name of the save directory (string)
    t.version = "0.9.0"         -- The LÖVE version this game was made for (string)
    t.console = true           -- Attach a console (boolean, Windows only)
    t.release = false           -- Enable release mode (boolean)
    t.window.width = 800        -- The window width (number)
    t.window.height = 600       -- The window height (number)
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = true       -- Enable vertical sync (boolean)
    t.window.fsaa = 0           -- The number of FSAA-buffers (number)
    t.window.resizable = true

end