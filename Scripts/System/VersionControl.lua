module("VersionControl", package.seeall)

local m_curVersion = nil;
local m_curPlatform = nil;

function initVersion()
    m_curVersion = VERSION_BUY_GAME;
    m_curPlatform = PLATFORM_APPLE;

    UIManager.effectInit();
end

function getCurVersion()
    return m_curVersion;
end

function getCurPlatform()
    return m_curPlatform;
end
