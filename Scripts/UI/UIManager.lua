module("UIManager", package.seeall)

require "CCBReaderLoad"
require "Confirm"
require "Splash"
require "MainMenu"
require "setting"
require "Help"
require "HeroUI"
require "TeamUI"
require "SceneSelect"
require "Settlement"
require "Mall"
require "Recharge"
require "About"

local m_proxy = nil;

local m_turnToSceneCB = nil;
local m_arrLayers = nil;


PATH_EFFECT_CANIN = nil;
PATH_EFFECT_CANNOTIN = nil;
PATH_EFFECT_BACK = nil;
PATH_EFFECT_GAMEBEGIN = nil;
PATH_EFFECT_NEWPOINTS = nil;
PATH_EFFECT_GIVESTARS = nil;

PATH_BGMUSIC_UI = PATH_RES_AUDIO .. "bg.mp3"

SCENE_BG_MUSIC_COUNT = 6
SPLASH_ID = 12;
MAINMENU_ID = 13;
TEAM_ID = 14;
MALL_ID = 15;
SCENESELECT_ID = 16;
SETTLEMENT_ID = 17;
ZHANDOU_ID = 18;

function effectInit()
    if(VersionControl.getCurPlatform() == PLATFORM_APPLE) then
        PATH_EFFECT_CANIN = PATH_RES_AUDIO .. "effect_canin.caf"
        PATH_EFFECT_CANNOTIN = PATH_RES_AUDIO .. "effect_cannotin.caf"
        PATH_EFFECT_BACK = PATH_RES_AUDIO .. "effect_back2.caf"
        PATH_EFFECT_GAMEBEGIN = PATH_RES_AUDIO .. "effect_gamebegin.caf"
        PATH_EFFECT_NEWPOINTS = PATH_RES_AUDIO .. "effect_newpoints.caf"
    elseif(VersionControl.getCurPlatform() == PLATFORM_ANDROID) then
        PATH_EFFECT_CANIN = PATH_RES_AUDIO .. "effect_canin.ogg"
        PATH_EFFECT_CANNOTIN = PATH_RES_AUDIO .. "effect_cannotin.ogg"
        PATH_EFFECT_BACK = PATH_RES_AUDIO .. "effect_back2.ogg"
        PATH_EFFECT_GAMEBEGIN = PATH_RES_AUDIO .. "effect_gamebegin.ogg"
        PATH_EFFECT_NEWPOINTS = PATH_RES_AUDIO .. "effect_newpoints.ogg"
        PATH_EFFECT_GIVESTARS = PATH_RES_AUDIO .. "effect_givestars.ogg"
    end
end


function turnToScene(sceneID, difficulty)
    m_turnToSceneCB(sceneID, difficulty);
end

local function loadCCBI(resName)
    local fileName = PATH_RES_UI .. resName .. ".ccbi", node;
    _G[resName].create();
    node = CCBuilderReaderLoad(fileName, m_proxy, ccb[resName]);
    m_arrLayers:addObject(node);
    _G[resName].setLayer(tolua.cast(node, "CCLayer"));
end

function loadAnimation(onLoadingEnd)
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGB5A1);
    AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);

    local resList = {};
    local count = PlayerInfo.getHeroTotalCount();
    for i = 1, count do
        local data = {resType = LOADING_TYPE_ANIM, resName = PlayerInfo.getHeroName(i)};
        table.insert(resList, data);
    end
    Loading.create(resList, onLoadingEnd);
end

local function readyToLoad()
    m_proxy = CCBProxy:create();
    m_proxy:retain();

    m_arrLayers = CCArray:create();
    m_arrLayers:retain();
    
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGB5A1);
end

function loadSplashCCBI()
    readyToLoad();
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888);
    AnimLoader:sharedInstance():setPath(PATH_CCB_ANIM);

    local splash = {resType = LOADING_TYPE_CCBI, resName = "Splash"};
    local startAnima = {resType = LOADING_TYPE_ANIM, resName = "start"};
    local resList = {splash, startAnima};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        Splash.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadSettingCCBI(ui)
    readyToLoad();

    local set = {resType = LOADING_TYPE_CCBI, resName = "setting"};
    local help = {resType = LOADING_TYPE_CCBI, resName = "Help"};
    local about = {resType = LOADING_TYPE_CCBI, resName = "About"};
    local resList = {set, help, about};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        setting.open(ui);
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadMainMenuCCBI()
    readyToLoad();

    local mainMenu = {resType = LOADING_TYPE_CCBI, resName = "MainMenu"};
    local confirm = {resType = LOADING_TYPE_CCBI, resName = "Confirm"};
    local resList = {mainMenu, confirm};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        MainMenu.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadSceneSelectCCBI(ui)
    readyToLoad();
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888);
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbres/heads.plist");
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbres/guanka.plist");
    
    local sceneSelect = {resType = LOADING_TYPE_CCBI, resName = "SceneSelect"};
    local resList = {sceneSelect};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        SceneSelect.open(ui);
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadHeroCCBI()
    readyToLoad();

    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbres/heads_dis.plist");

    local heroUI = {resType = LOADING_TYPE_CCBI, resName = "HeroUI"};
    local resList = {heroUI};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        HeroUI.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadTeamCCBI(ui)
    readyToLoad();

    local teamUI = {resType = LOADING_TYPE_CCBI, resName = "TeamUI"};
    local confirm = {resType = LOADING_TYPE_CCBI, resName = "Confirm"};
    local resList = {teamUI, confirm};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        TeamUI.open(ui);
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadSettlementCCBI()
    readyToLoad();
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbres/heads.plist");

    local settlement = {resType = LOADING_TYPE_CCBI, resName = "Settlement"};
    local resList = {settlement};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        Settlement.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadMallCCBI()
    readyToLoad();
    
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888);
    local mallUI = {resType = LOADING_TYPE_CCBI, resName = "Mall"};
    local recharge = {resType = LOADING_TYPE_CCBI, resName = "Recharge"};
    local confirm = {resType = LOADING_TYPE_CCBI, resName = "Confirm"};
    local resList = {mallUI, recharge, confirm};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        Mall.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

function loadRechargeCCBI()
    readyToLoad();
    
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888);
    local rechargeUI = {resType = LOADING_TYPE_CCBI, resName = "Recharge"};
    local mallUI = {resType = LOADING_TYPE_CCBI, resName = "Mall"};
    local confirm = {resType = LOADING_TYPE_CCBI, resName = "Confirm"};
    local resList = {rechargeUI, mallUI, confirm};

    local function onLoadingEnd()
        Loading.remove();
        m_proxy:release();
        m_proxy = nil;
        Recharge.open();
        CCTextureCache:sharedTextureCache():removeUnusedTextures();
    end

    Loading.create(resList, onLoadingEnd);
end

local function removeCommon()
    getSceneLayer(SCENE_UI_LAYER):removeAllChildrenWithCleanup(true);
    m_arrLayers:removeAllObjects();
    m_arrLayers:release();
    m_arrLayers = nil;
end

function removeSplashCCBI()
    Splash.remove();

    removeCommon();
end

function removeSettingCCBI()
    setting.remove();
    Help.remove();
    About.remove();

    removeCommon();
end

function removeMainMenuCCBI()
    MainMenu.remove();

    removeCommon();
end

function removeHeroCCBI()
    HeroUI.remove();

    removeCommon();
end

function removeTeamCCBI()
    TeamUI.remove();
    Confirm.remove();

    removeCommon();
end

function removeSceneSelectCCBI()
    SceneSelect.remove();

    removeCommon();
end

function removeSettlementCCBI()
    Settlement.remove();
    
    removeCommon();
end

function removeMallCCBI()
    Mall.remove();
    Recharge.remove();
    Confirm.remove();

    removeCommon();
end

function removeRechargeCCBI()
    Recharge.remove();
    Mall.remove();
    Confirm.remove();

    removeCommon();
end

function setTurnToSceneCB(fun)
    m_turnToSceneCB = fun;
end

function init()
    AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
    Loading.setCCBILoader(loadCCBI);
end

function showIAPResult(wasSuccess)
    Recharge.showResultBox(wasSuccess);
end