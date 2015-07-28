module("Loading", package.seeall)

local LOADING_TIP_COUNT = 9

local m_curStep = 1;
local m_stepMax = 1;
local m_resList = nil;

local m_ccbiLoader = nil;
local m_mapLoader = nil;
local m_callbackFun = nil;

local m_animLoader = AnimLoader:sharedInstance();

function setCCBILoader(loader)
    m_ccbiLoader = loader;
end

function setMapLoader(loader)
    m_mapLoader = loader;
end

local function init(resName)
    local layer = getSceneLayer(SCENE_LOADING_LAYER);
    if (layer:getChildrenCount() == 0) then
        math.randomseed(tostring(os.time()):reverse():sub(1, 6));
        local tipText = TEXT["loading_tip_" .. math.random(LOADING_TIP_COUNT)] or "";
        local bg = CCLayerColor:create(ccc4(0, 0, 0, 255));
        local actor = tolua.cast(AnimLoader:createAnimation(resName, "go"), "CCNode");
        local label = CCLabelTTF:create("Loading ...", "karakusaAA", 72);
        local tip = CCLabelTTF:create(tipText, "Marker Felt", 48);
        actor:setPosition(CCPoint(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.4));
        actor:setScale(0.7);
        label:setPosition(CCPoint(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.35));
        tip:setPosition(CCPoint(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.28));
        layer:addChild(bg);
        layer:addChild(actor, 1);
        layer:addChild(label);
        layer:addChild(tip);
    end
end

local function free()
    local layer = getSceneLayer(SCENE_LOADING_LAYER);
    layer:removeAllChildrenWithCleanup(true);
end

local function loadCCBI(resName)
    m_ccbiLoader(resName);
end

local function loadAnimation(resName)
    m_animLoader:loadAnimData(resName);
end

local function loadEvent(resName)
    SceneEventLoader:sharedInstance():loadEvents(resName);
end

local function loadScene(resName)
    SceneDataSource:sharedInstance():loadSceneData(resName);
end

local function loadTiles(id)
    m_mapLoader(id);
end

local function update()
    -- print("****** update  m_curStep " .. m_curStep);
    if (m_curStep > m_stepMax) then
        Loading.stop();
        m_callbackFun();
        return;
    end

    local resType = m_resList[m_curStep].resType;
    local resName = m_resList[m_curStep].resName;

    if (resType == LOADING_TYPE_INIT) then
        init(resName);
    elseif (resType == LOADING_TYPE_CCBI) then
        loadCCBI(resName);
    elseif (resType == LOADING_TYPE_ANIM) then
        loadAnimation(resName);
    elseif (resType == LOADING_TYPE_EVENT) then
        loadEvent(resName);
    elseif (resType == LOADING_TYPE_SCENE) then
        loadScene(resName);
    elseif (resType == LOADING_TYPE_TILE) then
        loadTiles(resName);
    end

    m_curStep = m_curStep + 1;
end

function start()
    -- print("****** start");
    local layer = getSceneLayer(SCENE_LOADING_LAYER);
    layer:scheduleUpdateWithPriorityLua(update, 1);
end

function stop()
    local layer = getSceneLayer(SCENE_LOADING_LAYER);
    layer:unscheduleUpdate();
end

local function insertRenderStep()
    local step = {resType = LOADING_TYPE_INIT, resName = "guanyu"};
    table.insert(m_resList, 1, step);
    m_stepMax = m_stepMax + 1;
end

function create(resList, cbFun)
    -- print("*************************** #resList " .. #resList);
    m_stepMax = #resList;
    m_resList = resList;
    m_curStep = 1;
    m_callbackFun = cbFun;
    insertRenderStep();
    start();
end

function remove()
    m_curStep = 1;
    m_stepMax = 1;
    m_resList = nil;
    m_callbackFun = nil;
    free();
end