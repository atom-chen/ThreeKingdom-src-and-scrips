module("setting", package.seeall)
-- 保存界面所有变量的表
local m_setting = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;

local m_musicBar = nil;
local m_soundBar = nil;
local m_parentId = 0;

-- 按钮回调事件，自定义
local function returnToSplash()
    setting.close();

    UIManager.removeSettingCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();

    UIManager.loadSplashCCBI();
end

local function returnToMainMenu()
    setting.close();

    UIManager.removeSettingCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();

    UIManager.loadMainMenuCCBI();
end

local function returnToParent()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	--音量存档
	DocManager.saveFloat("music_volume", PlayerInfo.getMusicVolume());
	DocManager.saveFloat("sound_volume", PlayerInfo.getSoundVolume());
    DocManager.flush();
    --切换界面
	if(m_parentId == UIManager.SPLASH_ID) then
		returnToSplash();
	elseif(m_parentId == UIManager.MAINMENU_ID) then
		returnToMainMenu();
	end
end

local function enterAboutInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    setting.close();
    About.open(m_parentId);
end

local function enterHelpInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    setting.close();
    Help.open();
end

local function musicChanged(mode, value)
	local volume = value:getValue();
	AudioEngine.setMusicVolume(volume);
	m_musicBar:setWidth(volume);
	PlayerInfo.setMusicVolume(volume);
end

local function soundChanged(mode, value)
	local volume = value:getValue();
	AudioEngine.setEffectsVolume(volume);
	m_soundBar:setWidth(volume);
	PlayerInfo.setSoundVolume(volume);
end

local function addVolumeBar(x, y, cb)
	local bgSprite = ClipSprite:create(PATH_CCB_ROOT .. "volume.png");
	local nullSprite1 = CCSprite:create(PATH_CCB_ROOT .. "hero-unlock.png");
	local nullSprite2 = CCSprite:create(PATH_CCB_ROOT .. "hero-unlock.png");
	local bottom = CCSprite:create(PATH_CCB_ROOT .. "volume_bottom.png");
	local musicBar = CCControlSlider:create(bgSprite, nullSprite1, nullSprite2);
	tolua.cast(musicBar, "CCNode"):setPosition(x, y);
	musicBar:setMinimumValue(0);
	musicBar:setMaximumValue(1);
	musicBar:registerScriptHandler(cb);
	tolua.cast(bottom, "CCNode"):setPosition(CCPoint(x, y));
	m_rootLayer:addChild(bottom);
	m_rootLayer:addChild(musicBar);
	return bgSprite;
end

local function initAudio()
	local musicVolume = PlayerInfo.getMusicVolume();
	local soundVolume = PlayerInfo.getSoundVolume();
	m_musicBar:setWidth(musicVolume);
	m_soundBar:setWidth(soundVolume);
end

-- 创建界面
function create()
	ccb["setting"] = {};
	m_setting = ccb["setting"];
	m_setting.backOnClick = returnToParent;
	m_setting.aboutOnClick = enterAboutInterface;
	m_setting.helpOnClick = enterHelpInterface;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
	m_musicBar = addVolumeBar(1100, 1075, musicChanged);
	m_soundBar = addVolumeBar(1100, 850, soundChanged);
end

-- 打开界面
function open(parentId)
	if (not m_isOpen) then
		m_isOpen = true;
		if (parentId) then
			m_parentId = parentId;
		end
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		initAudio();
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
		m_rootLayer:removeAllChildrenWithCleanup(true);
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
	end
	m_isOpen = false;
	m_setting = nil;
	m_rootLayer = nil;
	ccb["setting"] = nil;
end