require "PathManager"

setCommonPath();
loadScriptPath();

require "config"
require "Language"
require "GameManager"

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100);
    collectgarbage("setstepmul", 5000);

    GameManager.initGame();
end

xpcall(main, __G__TRACKBACK__);
