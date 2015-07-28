module("PauseInterface", package.seeall)

local m_rootLayer = nil;

local function restart()
    AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    PauseInterface.remove();
    SceneManager.unpauseGame();
    SceneManager.restartGame();
end

local function exit()
    AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
    PauseInterface.remove();
    SceneManager.unpauseGame();
    GameManager.enterUIFromScene(UI_TYPE_SCENE_SELECT);
end

local function close()
    PauseInterface.remove();
    SceneManager.unpauseGame();
end

function create()
	local layerUI = getSceneLayer(SCENE_INTERFACE_LAYER);
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 125));

    local imgRestart = CCScale9Sprite:create(PATH_RES_IMG_UI .. "Again.png");
    local imgExit = CCScale9Sprite:create(PATH_RES_IMG_UI .. "exit.png");
    local imgClose = CCScale9Sprite:create(PATH_CCB_ROOT .. "continue.png");
    local btnRestart = CCControlButton:create(imgRestart);
    local btnExit = CCControlButton:create(imgExit);
    local btnClose = CCControlButton:create(imgClose);

    btnRestart:setPosition(CCPoint(250, 100));
    btnRestart:setPreferredSize(CCSize(366, 120));
    btnExit:setPosition(CCPoint(650, 100));
    btnExit:setPreferredSize(CCSize(317, 120));
    btnClose:setPosition(CCPoint(SCREEN_WIDTH - 150, 100));
    btnClose:setPreferredSize(CCSize(185, 157));

    btnRestart:addHandleOfControlEvent(restart, CCControlEventTouchUpInside);
    btnExit:addHandleOfControlEvent(exit, CCControlEventTouchUpInside);
    btnClose:addHandleOfControlEvent(close, CCControlEventTouchUpInside);

    layer:addChild(btnRestart);
    layer:addChild(btnExit);
    layer:addChild(btnClose);
    layerUI:addChild(layer);

    m_rootLayer = layer;
end

function remove()
	m_rootLayer:removeFromParentAndCleanup(true);
end