module("FailInterface", package.seeall)

local m_rootLayer = nil;

local function restart()
    AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    FailInterface.remove();
    SceneManager.restartGame();
    SceneManager.unpauseGame();
end

local function exit()
    AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
    FailInterface.remove();
    SceneManager.unpauseGame();
    GameManager.enterUIFromScene(UI_TYPE_SCENE_SELECT);
end

function create()
	local layerUI = getSceneLayer(SCENE_INTERFACE_LAYER);
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 125));

    local imgFailed = CCSprite:create(PATH_RES_IMG_UI .. "failed.png");
    local imgRestart = CCScale9Sprite:create(PATH_RES_IMG_UI .. "Again.png");
    local imgExit = CCScale9Sprite:create(PATH_RES_IMG_UI .. "exit.png");
    local btnRestart = CCControlButton:create(imgRestart);
    local btnExit = CCControlButton:create(imgExit);

    imgFailed:setPosition(CCPoint(SCREEN_WIDTH / 2, 900));
    btnRestart:setPosition(CCPoint(SCREEN_WIDTH - 500, 400));
    btnRestart:setPreferredSize(CCSize(366, 120));
    btnExit:setPosition(CCPoint(500, 400));
    btnExit:setPreferredSize(CCSize(317, 120));

    btnRestart:addHandleOfControlEvent(restart, CCControlEventTouchUpInside);
    btnExit:addHandleOfControlEvent(exit, CCControlEventTouchUpInside);

    layer:addChild(imgFailed);
    layer:addChild(btnRestart);
    layer:addChild(btnExit);
    layerUI:addChild(layer);

    m_rootLayer = layer;
end

function remove()
	m_rootLayer:removeFromParentAndCleanup(true);
end


