module("HeroUI", package.seeall)
require "DocManager"

-- 保存界面所有变量的表
local m_hero = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
-- 全身像
local m_portrait = nil;
-- 当前选中武将的ID
local m_curSelectID = 1;

local m_scrollView = nil;
local m_heroButtons = nil;
local m_buttonIndex = nil;
local m_heroStars = nil;
local m_btnExchange = nil;

local m_scrollLayer = nil;

-- 按钮回调事件，自定义

local function returnToMainMenu()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	HeroUI.close();

	UIManager.removeHeroCCBI();
    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads_dis.plist");
    CCTextureCache:sharedTextureCache():removeUnusedTextures();
    
    UIManager.loadMainMenuCCBI();
end

local function showHeroPortrait(id)
	local actor = Actor:createActor(PlayerInfo.getHeroName(id), 790, 0);
	m_portrait = tolua.cast(actor, "CCNode");
	m_portrait:setPosition(CCPoint(m_portrait:getPositionX() + 540, m_portrait:getPositionY()));
	m_rootLayer:addChild(m_portrait, 10);
end

local function showHeroInfomation(id)
	local key = PlayerInfo.getHeroName(id);
	local data = HeroData.getData(key);
	local name = TEXT[key];
	local quality = data.quality;
	local skill = TEXT["none"];
	if(id == 9 or id == 26) then
		skill = TEXT["addLife"];
	end
	if(id == 11 or id == 20) then
		skill = TEXT["addDef"];
	end
	if(id == 10 or id == 3) then
		skill = TEXT["addAtt"];
	end

	local job = TEXT[data.job];
	local desc = TEXT["get_" .. key];
	if (data.skill and data.skill > 0) then
		skill = TEXT[SkillData.getSkillIndex(data.skill).name];
	end
	tolua.cast(m_hero.heroName, "CCLabelTTF"):setString(name);
	tolua.cast(m_hero.skillName, "CCLabelTTF"):setString(skill);
	tolua.cast(m_hero.jobName, "CCLabelTTF"):setString(job);
	tolua.cast(m_hero.getWayContent, "CCLabelTTF"):setString(desc);
	for i = 1, quality do
		tolua.cast(m_heroStars[i], "CCSprite"):setVisible(true);
	end
	for i = quality + 1, 4 do
		tolua.cast(m_heroStars[i], "CCSprite"):setVisible(false);
	end
	m_btnExchange:setEnabled(m_scrollLayer:getChildByTag(id):isVisible());


	local zhangliangId = PlayerInfo.getHeroID("zhangliang");
	if(id == zhangliangId) then
		if(PlayerInfo.getHeroEnabled(zhangliangId) == false and GameGuide.isHeroCanEnable()) then
			local particle = ParticleSysManager.createParticleSimple("", ccp(158,60), 0);
			-- local particle = tolua.cast(AnimLoader:createAnimation(GameGuide.getGuideResName(), GameGuide.getGuideAnimName()), "CCNode");
			-- particle:setPosition(ccp(158,60));
			if(m_btnExchange:getChildByTag(10) == nil) then
				m_btnExchange:addChild(particle, 10, 10);
				particle:runAction(ParticleSysManager.getRotateAction());
			end
		end
	else
		if(m_btnExchange:getChildByTag(10) ~= nil) then
			m_btnExchange:removeChildByTag(10, true);
		end
	end
end

-- 点击合成按钮
local function exchange()
	if(PlayerInfo.getHeroEnabled(m_curSelectID) == false) then
		AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
		Exchange.exchangeBonus(m_curSelectID);
		local name = PlayerInfo.getHeroName(m_curSelectID) .. ".png";
		local imgNormal = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name);
		local button = m_heroButtons[m_curSelectID];
		m_heroButtons[m_curSelectID]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateNormal);
		m_heroButtons[m_curSelectID]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateHighlighted);
		m_heroButtons[m_curSelectID]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateDisabled);
		m_scrollLayer:getChildByTag(m_curSelectID):setVisible(false);
		m_btnExchange:setEnabled(false);

		local zhangliangId = PlayerInfo.getHeroID("zhangliang");
		if(m_curSelectID == zhangliangId) then
			GameGuide.setHeroEnableFinish(true);
			m_heroButtons[zhangliangId]:removeChildByTag(10, true);
			m_btnExchange:removeChildByTag(10, true);
		end

		--合成完毕，保存数据
		DocManager.saveBool("hero_enable_" .. m_curSelectID, true);
		DocManager.flush();
	end
end

local function selectHero(desc, button)
	button = tolua.cast(button, "CCControlButton");
	m_curSelectID = m_buttonIndex[button];
	if(PlayerInfo.getHeroEnabled(m_curSelectID) == true) then
		AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	else
		AudioEngine.playEffect(UIManager.PATH_EFFECT_CANNOTIN, false);
	end
	m_portrait:removeFromParentAndCleanup(true);
	showHeroPortrait(m_curSelectID);
	showHeroInfomation(m_curSelectID);
end

local function createScrollView()
	ccb["HeroScreen"] = {};
	m_scrollView = ccb["HeroScreen"];
	m_scrollView.selectHero = selectHero;
	m_heroButtons = {};
	m_buttonIndex = {};
end

local function removeScrollView()
	ccb["HeroScreen"] = nil;
	m_scrollView = nil;
	m_heroButtons = nil;
	m_buttonIndex = nil;
	m_scrollLayer = nil;
end

local function attachScrollViewButtons()
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		m_heroButtons[i] = tolua.cast(ccb["HeroScreen"]["hero_" .. i], "CCControlButton");
		m_buttonIndex[m_heroButtons[i]] = i;
	end
end

local function attachHeroStars()
	for i = 1, 4 do
		m_heroStars[i] = tolua.cast(m_hero["star_" .. i], "CCSprite");
	end
end

local function setButtonsStatus()
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		local isEnabled = PlayerInfo.getHeroEnabled(i);
		if (isEnabled == false) then
			local name = PlayerInfo.getHeroName(i) .. "_dis" .. ".png";
			local imgNormal = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name);
			m_heroButtons[i]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateNormal);
			m_heroButtons[i]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateHighlighted);
			m_heroButtons[i]:setBackgroundSpriteFrameForState(imgNormal, CCControlStateDisabled);

			local canExchange = Exchange.checkIsEnabled(i);
			m_scrollLayer:getChildByTag(i):setVisible(canExchange);

		end
	end
end

local function addGuide()
	if(GameGuide.getHeroEnableFinish() == false) then
		if(GameGuide.isHeroCanEnable() == true) then
			local particle = ParticleSysManager.createParticleSimple("", ccp(109, 107), 1.3);
			-- local particle = tolua.cast(AnimLoader:createAnimation(GameGuide.getGuideResName(), GameGuide.getGuideAnimName()), "CCNode");
			-- particle:setPosition(ccp(109,107));
			local zhangliangId = PlayerInfo.getHeroID("zhangliang");
			m_heroButtons[zhangliangId]:addChild(particle, 10, 10);
			particle:runAction(ParticleSysManager.getRotateAction());
		end
	end
end

local function removeGuide()
	if(GameGuide.getHeroEnableFinish() == false) then
		local zhangliangId = PlayerInfo.getHeroID("zhangliang");
		if(m_heroButtons[zhangliangId]:getChildByTag(10)) then
			m_heroButtons[zhangliangId]:removeChildByTag(10, true);
		end
		if(m_btnExchange:getChildByTag(10)) then
			m_btnExchange:removeChildByTag(10, true);
		end
	end
end

-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["HeroUI"] = {};
	m_hero = ccb["HeroUI"];
	m_hero.backOnClick = returnToMainMenu;
	m_hero.exchangeOnClick = exchange;
	m_heroStars = {};

	createScrollView();
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;

	attachHeroStars(); 
	m_btnExchange = tolua.cast(m_hero.exchange, "CCControlButton"); 
	local scrollView = tolua.cast(m_hero.heroList, "CCScrollView");
	m_scrollLayer = scrollView:getContainer(); 
	attachScrollViewButtons(); 
	setButtonsStatus(); 
	scrollView:setContentOffset(CCPoint(0, -2450), false);
end

-- 打开界面
function open()
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);

		showHeroPortrait(m_curSelectID);
		showHeroInfomation(m_curSelectID);
		addGuide();
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:removeChild(m_rootLayer, false);
		m_portrait:removeFromParentAndCleanup(true);
		m_portrait = nil;

		removeGuide();
	end
end

-- 删除界面
function remove()
	if (m_rootLayer) then
		m_rootLayer:removeAllChildrenWithCleanup(true);
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
	end
	m_isOpen = false;
	m_hero = nil;
	m_rootLayer = nil;
	ccb["HeroUI"] = nil;
	m_heroStars = nil;

	removeScrollView();
end