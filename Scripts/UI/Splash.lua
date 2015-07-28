module("Splash", package.seeall)

-- 保存界面所有变量的表
local m_splash = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;

-- 按钮回调事件，自定义
local function enterMainMenu()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_GAMEBEGIN, false);
	Splash.close();

	UIManager.removeSplashCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
	
	UIManager.loadMainMenuCCBI();
end

local function enterSetting()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	Splash.close();

	UIManager.removeSplashCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
	
	UIManager.loadSettingCCBI(UIManager.SPLASH_ID);
end

local function addStartAnimation()
	local anim = AnimLoader:createAnimation("start", "stand");
	local start = tolua.cast(anim, "CCNode");
	start:setAnchorPoint(ccp(0.5, 0.5));
	start:setPosition(CCPoint(1024, 123));
	start:setScale(1.5);
	m_rootLayer:addChild(start, 10);
end

-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["Splash"] = {};
	m_splash = ccb["Splash"];

	m_splash.startOnClick = enterMainMenu;
	m_splash.settingOnClick = enterSetting;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
end

-- 打开界面
function open()
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		addStartAnimation();
		layer:addChild(m_rootLayer);
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:removeChild(m_rootLayer, false);
	end
end

-- 删除界面
function remove()
	if (m_rootLayer) then
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
		m_rootLayer:removeAllChildrenWithCleanup(true);

	end
	m_isOpen = false;
	m_startTag = nil;
	m_splash  = nil;
	m_rootLayer = nil;
	ccb["Splash"] = nil;
end