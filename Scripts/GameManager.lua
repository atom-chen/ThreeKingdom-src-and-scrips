module("GameManager", package.seeall)

require "AudioEngine"
require "SceneManager"
require "UIManager"
require "ActorManager"
require "HeroManager"
require "EffectManager"
require "DocManager"
require "PlayerInfo"
require "MapData"
require "Exchange"
require "LayerManager"
require "Loading"
require "IAPManager"
require "GameGuide"
require "ParticleSysManager"
require "VersionControl"

local m_tempData = nil;

local m_heroTextureCache = nil;

local function giveCommodity(productID)
    if (productID == 1) then
        PlayerInfo.modifyToken(108);
    elseif (productID == 2) then
        PlayerInfo.modifyToken(238);
    elseif (productID == 3) then
        PlayerInfo.modifyToken(788);
    elseif (productID == 4) then
        PlayerInfo.modifyToken(2388);
    end
end

function getHeroTextureCache()
    return m_heroTextureCache;
end

local function retainHeroTexture()
    local textureCache = CCTextureCache:sharedTextureCache();
    local count = PlayerInfo.getHeroTotalCount();
    for i = 1, count do
        local name = PATH_RES_HEROES .. PlayerInfo.getHeroName(i) .. "0.png";
        local texture = textureCache:textureForKey(name);
        m_heroTextureCache:addObject(texture);
    end
end

local function releaseHeroTexture()
    m_heroTextureCache:removeAllObjects();
end

local function purgeAllResources()
    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames();
    AnimLoader:sharedInstance():purge();
    CCTextureCache:sharedTextureCache():purge();
end

local function loadUI()
    retainHeroTexture();
    UIManager.loadSceneSelectCCBI(UIManager.ZHANDOU_ID);
end

function enterUIFromScene(uiType)
    SceneManager.exitScene();
    purgeAllResources();
    AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
    if (uiType == UI_TYPE_SCENE_SELECT) then
        UIManager.loadAnimation(loadUI);
    elseif (uiType == UI_TYPE_SCENE_LOOT) then
        UIManager.loadSettlementCCBI();
    end
end

function enterSceneFromUI(sceneID, difficulty)
	UIManager.removeSceneSelectCCBI();
    releaseHeroTexture();
    purgeAllResources();
    AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
    SceneManager.enterScene(sceneID, difficulty, enterUIFromScene);
end

function enterSceneFromSettlement(sceneID, difficulty)
    UIManager.removeSettlementCCBI();
    releaseHeroTexture();
    purgeAllResources();
    AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
    SceneManager.enterScene(sceneID, difficulty, enterUIFromScene);
end

local function loadAudioFile()
    AudioEngine.preloadEffect(PATH_RES_AUDIO .. "slash.caf");
    AudioEngine.preloadEffect(PATH_RES_AUDIO .. "arraw.caf");

    AudioEngine.preloadEffect(UIManager.PATH_EFFECT_CANIN);
    AudioEngine.preloadEffect(UIManager.PATH_EFFECT_CANNOTIN);
    AudioEngine.preloadEffect(UIManager.PATH_EFFECT_BACK);
    AudioEngine.preloadEffect(UIManager.PATH_EFFECT_GAMEBEGIN);
    AudioEngine.preloadEffect(UIManager.PATH_EFFECT_NEWPOINTS);
    -- AudioEngine.preloadEffect(UIManager.PATH_EFFECT_GIVESTARS);

    AudioEngine.preloadMusic(UIManager.PATH_BGMUSIC_UI);
end

local function loadAnimEnd()
    AudioEngine.playMusic(UIManager.PATH_BGMUSIC_UI, true);
    Loading.remove();
    retainHeroTexture();
    UIManager.loadSplashCCBI();
end

local function finishTransaction(result, value)
    local id = value:getValue();
    local isSuccess = false;

    if (result == "true") then
        isSuccess = true;
        giveCommodity(id);
    end
    UIManager.showIAPResult(isSuccess);
end

function initGame()

    VersionControl.initVersion();
    
    if(VersionControl.getCurVersion() == VERSION_IAP_GAME) then
        IAPManager.init();
        IAPManager.registerCallbackFunction(finishTransaction);
    end

    m_heroTextureCache = CCArray:create();
    m_heroTextureCache:retain();

    CCFileUtils:sharedFileUtils():addSearchPath("Res/UI");
    CCFileUtils:sharedFileUtils():addSearchPath("fonts");
    
	local sceneGame = CCScene:create();
    CCDirector:sharedDirector():runWithScene(sceneGame);
    PlayerInfo.loadAllInfo();

    createSceneLayer(sceneGame);
    ArcBackground:initData();

    AudioEngine.setMusicVolume(PlayerInfo.getMusicVolume());
    AudioEngine.setEffectsVolume(PlayerInfo.getSoundVolume());
    loadAudioFile();

    SceneManager.registerFunOnLoading();

    UIManager.init();
    UIManager.setTurnToSceneCB(enterSceneFromUI);
    UIManager.loadAnimation(loadAnimEnd);
    -- UIManager.loadSplashCCBI();
end

