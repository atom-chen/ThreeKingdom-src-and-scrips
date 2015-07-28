module("MainMenu", package.seeall)

require "GameGuide"

-- 保存界面所有变量的表
local m_mainMenu = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
local m_guideParticle = nil;
--local m_guidePos = {ccp(400, 800), ccp(400, 500)};--武将、组队
local m_guidePos = nil;

local PRO_ATTACK = 1;
local PRO_HERO 	 = 2;
local PRO_TEAM 	 = 3;
local m_promptFlag = nil;

local function closeConfirm()
	Confirm.close();
end

-- 按钮回调事件，自定义
local function enterHeroInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);

	--消除提示
	if(m_promptFlag[PRO_HERO] == 1) then
		m_mainMenu.menu_hero:removeChildByTag(10, true);
	end

    MainMenu.close();

    UIManager.removeMainMenuCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

    UIManager.loadHeroCCBI();
end

local function enterTeamInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    MainMenu.close();

    UIManager.removeMainMenuCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();


    UIManager.loadTeamCCBI(UIManager.MAINMENU_ID);
end

local function enterSceneSelect()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);

	--消除提示
	if(m_promptFlag[PRO_ATTACK] == 1) then
		m_mainMenu.menu_attack:removeChildByTag(10, true);
		DocManager.saveBool("isAttackProptFinish", true);
	end

	MainMenu.close();

	UIManager.removeMainMenuCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();
	
	UIManager.loadSceneSelectCCBI();
end

local function enterToSetting()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	MainMenu.close();

	UIManager.removeMainMenuCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
	
	UIManager.loadSettingCCBI(UIManager.MAINMENU_ID);
end

local function enterToMall()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	if(VersionControl.getCurVersion() == VERSION_BUY_GAME) then
		Confirm.open(TEXT.mall_no_open);
		Confirm.setCallBackFunction(closeConfirm, closeConfirm);
	else
	    MainMenu.close();

	    UIManager.removeMainMenuCCBI();
	    CCTextureCache:sharedTextureCache():removeUnusedTextures();

	    UIManager.loadMallCCBI();
	end
end

--进入充值界面
local function enterShop()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
    MainMenu.close();

    UIManager.removeMainMenuCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

	UIManager.loadRechargeCCBI();
end

local function refreshMoney()
	local money = PlayerInfo.getMoney();
	tolua.cast(m_mainMenu.money, "CCLabelTTF"):setString("" .. money);
end

local function refreshYuanbao()
	local yuanbao = PlayerInfo.getToken();
	tolua.cast(m_mainMenu.yuanbao, "CCLabelTTF"):setString("" .. yuanbao);
end

--检查提示
--包括：首次运行：讨伐提示；  新武将可解锁；
local function checkPrompt()
	m_promptFlag = {0, 0, 0};
	--讨伐
	local isAttackProptFinish = DocManager.loadBool("isAttackProptFinish");
	if(isAttackProptFinish == false) then
		m_promptFlag[PRO_ATTACK] = 1;
		local attackNode = tolua.cast(m_mainMenu.menu_attack, "CCNode");
		local attackParticleProm = ParticleSysManager.createParticleSimple("", ccp(286, 900), 3);
		attackNode:addChild(attackParticleProm, 10, 10);
		attackParticleProm:runAction(ParticleSysManager.getRotateAction());
	end
	--武将
	if(GameGuide.getHeroEnableFinish() == false)then
		if(GameGuide.isHeroCanEnable()) then
			m_promptFlag[PRO_HERO] = 1;
			local heroParticleProm = ParticleSysManager.createParticleSimple("", ccp(200, 230), 2);
			m_mainMenu.menu_hero:addChild(heroParticleProm, 10, 10);
			heroParticleProm:runAction(ParticleSysManager.getRotateAction());
		end
	end
	--组队
	if(GameGuide.canShowUpgradeGuide()) then
		local par = ParticleSysManager.createParticleSimple("", ccp(200, 100), 2);
		par:runAction(ParticleSysManager.getRotateAction());
		m_mainMenu.menu_team:addChild(par, 10, 10);
	end
end

local function versionControl()
	if(VersionControl.getCurVersion() == VERSION_BUY_GAME) then
		tolua.cast(m_mainMenu.menu_mall, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_mainMenu.menu_mall, "CCControlButton"):setVisible(false);
		tolua.cast(m_mainMenu.menu_shop, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_mainMenu.menu_shop, "CCControlButton"):setVisible(false);
	end
end

-- 创建界面
function create()
	ccb["MainMenu"] = {};
	m_mainMenu = ccb["MainMenu"];

	m_mainMenu.heroOnClick = enterHeroInterface;
	m_mainMenu.teamOnClick = enterTeamInterface;
	m_mainMenu.attackOnClick = enterSceneSelect;
	m_mainMenu.mallOnClick = enterToMall;
	m_mainMenu.shopOnClick = enterShop;
	m_mainMenu.setting = enterToSetting;
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
		layer:addChild(m_rootLayer);
		refreshMoney();
		refreshYuanbao();

		checkPrompt();
		versionControl();
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
	m_mainMenu = nil;
	m_rootLayer = nil;
	ccb["MainMenu"] = nil;
end