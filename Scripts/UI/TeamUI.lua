module("TeamUI", package.seeall)
require "DocManager"

local SUPPORTED_COUNT = 6
local ATTACKER_COUNT = 10
local LEADER_COUNT = 3
local TANK_COUNT = 10

local SCROLL_ITEM_DISTANCE = 400;

local SCROLL_HEIGHT = {
		TANK_COUNT * SCROLL_ITEM_DISTANCE,
		LEADER_COUNT * SCROLL_ITEM_DISTANCE,
		ATTACKER_COUNT * SCROLL_ITEM_DISTANCE,
		SUPPORTED_COUNT * SCROLL_ITEM_DISTANCE
};

-- 保存界面所有变量的表
local m_team = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
local m_parentId = 0;

local m_supported = nil;
local m_attacker = nil;
local m_leader = nil;
local m_tank = nil;

local m_supportedHeroes = nil;
local m_attackerHeroes = nil;
local m_leaderHeroes = nil;
local m_tankHeroes = nil;

local m_supportedLayer = nil;
local m_attackerLayer = nil;
local m_leaderLayer = nil;
local m_tankLayer = nil;

local m_selectedHero = 0;
local m_selectedHeroNode = nil;
local m_guideFinishFlag = false;
local m_upFlag = false;
local m_isEquipHeroGuideFlag = false;

local function getHeroKey(name, level)
	local key = name;
	if (level > 0) then
		key = key .. "_" .. level;
	end
	return key;
end

local function getHeroAtk(key)
	local atkPhy = HeroData.getData(key).atk_phy;
	local atkPsy = HeroData.getData(key).atk_psy;
	if (atkPhy > atkPsy) then
		return atkPhy, "attack_phy";
	else
		return atkPsy, "attack_psy";
	end
end

local function getHeroDef(key)
	local defPhy = HeroData.getData(key).def_phy;
	local defPsy = HeroData.getData(key).def_psy;
	if (defPhy > defPsy) then
		return defPhy, "defense_phy";
	else
		return defPsy, "defense_psy";
	end
end

local function refreshMoney()
	local money = PlayerInfo.getMoney();
	tolua.cast(m_team.money, "CCLabelTTF"):setString("" .. money);
end

local function refreshYuanbao()
	local yuanbao = PlayerInfo.getToken();
	tolua.cast(m_team.yuanbao, "CCLabelTTF"):setString("" .. yuanbao);
end

local function showHeroInfo(id)
	local name = PlayerInfo.getHeroName(id);
	local level = PlayerInfo.getHeroLevel(id);
	local levelNew = PlayerInfo.getHeroNextLevel(id);
	local key = getHeroKey(name, level);
	local keyNew = getHeroKey(name, levelNew);
	local hp = HeroData.getData(key).hp;
	local hpNew = HeroData.getData(keyNew).hp;
	local atkValue, atkName = getHeroAtk(key);
	local atkValueNew, atkNameNew = getHeroAtk(keyNew);
	local defValue, defName = getHeroDef(key);
	local defValueNew, defNameNew = getHeroDef(keyNew);
	local cost = HeroData.getData(getHeroKey(name, levelNew)).money or 0;
	local money = PlayerInfo.getMoney();
	-- 强化前
	tolua.cast(m_team.heroNameL, "CCLabelTTF"):setString(TEXT[name]);
	tolua.cast(m_team.levelValueL, "CCLabelTTF"):setString("" .. (level + 1));
	tolua.cast(m_team.HPValueL, "CCLabelTTF"):setString("" .. hp);
	tolua.cast(m_team.attackNameL, "CCLabelTTF"):setString("" .. TEXT[atkName]);
	tolua.cast(m_team.attackValueL, "CCLabelTTF"):setString("" .. atkValue);
	tolua.cast(m_team.defenseNameL, "CCLabelTTF"):setString("" .. TEXT[defName]);
	tolua.cast(m_team.defenseValueL, "CCLabelTTF"):setString("" .. defValue);
	-- 强化后
	tolua.cast(m_team.heroNameR, "CCLabelTTF"):setString(TEXT[name]);
	tolua.cast(m_team.levelValueR, "CCLabelTTF"):setString("" .. (levelNew + 1));
	tolua.cast(m_team.HPValueR, "CCLabelTTF"):setString("" .. hpNew);
	tolua.cast(m_team.attackNameR, "CCLabelTTF"):setString("" .. TEXT[atkNameNew]);
	tolua.cast(m_team.attackValueR, "CCLabelTTF"):setString("" .. atkValueNew);
	tolua.cast(m_team.defenseNameR, "CCLabelTTF"):setString("" .. TEXT[defNameNew]);
	tolua.cast(m_team.defenseValueR, "CCLabelTTF"):setString("" .. defValueNew);
	-- 强化按钮
	tolua.cast(m_team.advanceCost, "CCLabelTTF"):setString("" .. cost);
	tolua.cast(m_team.advance, "CCControlButton"):setEnabled(level < levelNew);
	-- 显示信息
	m_team.menu:setVisible(true);

	local liubei = PlayerInfo.getHeroID("liubei");
	if(id == liubei and PlayerInfo.getHeroLevel(liubei) == 0) then
		if(m_upFlag == false) then
			m_upFlag = true;
			local upgradeGuide2Par = ParticleSysManager.createParticleSimple("", ccp(158,85), 0);
			tolua.cast(m_team.advance, "CCControlButton"):addChild(upgradeGuide2Par, 10, 10);
			upgradeGuide2Par:runAction(ParticleSysManager.getRotateAction());
			removeGuide();
		end
	end
end

-- 按钮回调事件，自定义
local function returnToLastUI()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	if(m_isEquipHeroGuideFlag) then
		m_supportedHeroes[2]:removeChildByTag(10, true);
	end

	--组队存档
	DocManager.saveArrayInt("queue", PlayerInfo.getQueue());
	DocManager.flush();

    TeamUI.close();

    UIManager.removeTeamCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();
    
    --返回对应位置
    if(m_parentId == UIManager.MAINMENU_ID) then
    	UIManager.loadMainMenuCCBI();
	elseif(m_parentId == UIManager.SCENESELECT_ID) then
    	UIManager.loadSceneSelectCCBI();
	end
end

local function enterShop()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	TeamUI.close();

	UIManager.removeTeamCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

	UIManager.loadRechargeCCBI();
end

local function enterMall()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    TeamUI.close();

    UIManager.removeTeamCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

    UIManager.loadMallCCBI();
end

--播放升级特效
local function playAdvanceEffect()
	ParticleSysManager.createParticle( "upgrade", ccp(145, 165), 4, m_selectedHeroNode );

	local upAnim = CCSprite:create(PATH_RES_OTHER .. "qianhuachenggong0.png");
	local function spawnEnd()
		tolua.cast(upAnim, "CCNode"):removeFromParentAndCleanup(true);
	end
	local arr = CCArray:create();
	local sarr = CCArray:create();
	sarr:addObject(CCMoveBy:create(0.6, ccp(0, 300)));
	sarr:addObject(CCScaleBy:create(0.6, 1.2));
	sarr:addObject(CCFadeTo:create(0.6, 100));
	local spawn = CCSpawn:create(sarr);
	arr:addObject(spawn);
	arr:addObject(CCCallFunc:create(function() spawnEnd() end));
	tolua.cast(upAnim, "CCNode"):setScale(1.5);
	tolua.cast(upAnim, "CCNode"):setPosition(ccp(160, 0));
	m_selectedHeroNode:addChild(tolua.cast(upAnim, "CCNode"), 11);
	tolua.cast(upAnim, "CCNode"):runAction(CCSequence:create(arr));
end

local function advanceHero()
    local name = PlayerInfo.getHeroName(m_selectedHero);
	local level = PlayerInfo.getHeroLevel(m_selectedHero);
	local levelNew = PlayerInfo.getHeroNextLevel(m_selectedHero);
    local key = getHeroKey(name, levelNew);
    local money = PlayerInfo.getMoney();
    local cost = HeroData.getData(key).money or 0; 
    if (money >= cost) then
		AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
		if(level < levelNew) then 
			PlayerInfo.modifyMoney(-cost);
		    PlayerInfo.modifyHeroLevel(m_selectedHero, 1);
		    showHeroInfo(m_selectedHero);
		    refreshMoney();
		    --删除引导
		    local liubei = PlayerInfo.getHeroID("liubei");
			if(m_selectedHero == liubei and PlayerInfo.getHeroLevel(liubei) == 1) then
				GameGuide.setHeroStrengFinish(true);
				m_leaderHeroes[1]:removeChildByTag(10, true);
				tolua.cast(m_team.advance, "CCControlButton"):removeChildByTag(10, true);

				--返回按钮引导
				local par = ParticleSysManager.createParticleSimple("", ccp(77, 63), 1.3);
				par:runAction(ParticleSysManager.getRotateAction());
				m_team.back:addChild(par, 10, 10);
			end

			--播放升级特效
			playAdvanceEffect();
			
		    --保存金币数量和人物当前等级
		    DocManager.saveInt("money", PlayerInfo.getMoney());
		    DocManager.saveInt("hero_level_" .. m_selectedHero, PlayerInfo.getHeroLevel(m_selectedHero));
		    DocManager.flush();
		end
	else
		AudioEngine.playEffect(UIManager.PATH_EFFECT_CANNOTIN, false);
		m_rootLayer:onExit();
		Confirm.open(TEXT["money_not_enough"]);
	end
end

local function selectHero(desc, button)
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	m_selectedHero = tolua.cast(button, "CCNode"):getTag();
	m_selectedHeroNode = tolua.cast(button, "CCNode");
	showHeroInfo(m_selectedHero);
end

local function unselectHero(button)
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANNOTIN, false);
	m_team.menu:setVisible(false);
	if(tolua.cast(m_team.advance, "CCControlButton"):getChildByTag(10) ~= nil) then
		tolua.cast(m_team.advance, "CCControlButton"):removeChildByTag(10, true);
	end
end

local function openShop()
	Confirm.close();
	m_rootLayer:onEnter();
	TeamUI.close();
	enterShop();
end

local function notOpenShop()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANNOTIN, false);
	Confirm.close();
	m_rootLayer:onEnter();
end

local function createList()
	ccb["SupportedList"] = {};
	m_supported = ccb["SupportedList"];
	m_supported.selectHero = selectHero;
	m_supportedHeroes = {};

	ccb["AttackerList"] = {};
	m_attacker = ccb["AttackerList"];
	m_attacker.selectHero = selectHero;
	m_attackerHeroes = {};

	ccb["LeaderList"] = {};
	m_leader = ccb["LeaderList"];
	m_leader.selectHero = selectHero;
	m_leaderHeroes = {};

	ccb["TankList"] = {};
	m_tank = ccb["TankList"];
	m_tank.selectHero = selectHero;
	m_tankHeroes = {};
end

local function removeList()
	m_supported = nil;
	ccb["SupportedList"] = nil;
	m_supportedLayer = nil;
	m_supportedHeroes = nil;

	m_attacker = nil;
	ccb["AttackerList"] = nil;
	m_attackerLayer = nil;
	m_attackerHeroes = nil;

	m_leader = nil;
	ccb["LeaderList"] = nil;
	m_leaderLayer = nil;
	m_leaderHeroes = nil;

	m_tank = nil;
	ccb["TankList"] = nil;
	m_tankLayer = nil;
	m_tankHeroes = nil;
end

local function attachListController()
	m_supportedLayer = tolua.cast(m_team.supportedList, "CCScrollView");
	for i = 1, SUPPORTED_COUNT do
		m_supportedHeroes[i] = tolua.cast(m_supported["hero_" .. i], "CCLayer");
	end

	m_attackerLayer = tolua.cast(m_team.attackerList, "CCScrollView");
	for i = 1, ATTACKER_COUNT do
		m_attackerHeroes[i] = tolua.cast(m_attacker["hero_" .. i], "CCLayer");
	end

	m_leaderLayer = tolua.cast(m_team.leaderList, "CCScrollView");
	for i = 1, LEADER_COUNT do
		m_leaderHeroes[i] = tolua.cast(m_leader["hero_" .. i], "CCLayer");
	end

	m_tankLayer = tolua.cast(m_team.tankList, "CCScrollView");
	for i = 1, TANK_COUNT do
		m_tankHeroes[i] = tolua.cast(m_tank["hero_" .. i], "CCLayer");
	end
end

local function setHeroAnim(id)
	local name = PlayerInfo.getHeroName(id);
	local anim = Actor:createAnimation(name, "stand", 0);
	return tolua.cast(anim, "CCNode");
end

local function setHeroStatus(allList)
	local centerPos = allList[1][1]:getContentSize().width / 2;
	for i, list in ipairs(allList) do
		for j, layer in ipairs(list) do
			local id = tolua.cast(layer, "CCNode"):getTag();
			local isEnabled = PlayerInfo.getHeroEnabled(id);
			tolua.cast(layer:getChildByTag(id), "CCControlButton"):setEnabled(isEnabled);
			-- 添加动画
			local anim = setHeroAnim(id);
			anim:setPosition(centerPos, 20);
			layer:addChild(anim, -1);
		end
	end
end

local function changeStar(index, heroID)
	if(heroID == 0) then
		for i = 1,5 do
			tolua.cast(m_team["star_" .. index .. "_" .. i], "CCSprite"):setVisible(false);
		end
	else
		local key = PlayerInfo.getHeroName(heroID);
		local data = HeroData.getData(key);
		local quality = data.quality;
		for i = 1,quality do
			tolua.cast(m_team["star_" .. index .. "_" .. i], "CCSprite"):setVisible(true);
		end
		for i = quality + 1,5 do
			tolua.cast(m_team["star_" .. index .. "_" .. i], "CCSprite"):setVisible(false);
		end
	end
end

local function initStars()
	local queue = PlayerInfo.getQueue();
	for i = 1,4 do
		changeStar(i, queue[i]);
	end
end

local function changeQueue(index, pos)
	local itemID = math.floor((SCROLL_HEIGHT[index] + pos) / SCROLL_ITEM_DISTANCE);
	local heroID = 0;
	if (index == 2) then
		itemID = math.max(itemID, 1);
	else
		itemID = math.max(itemID, 0);
	end
	if (itemID > 0) then
		if (index == 1) then
			heroID = m_tankHeroes[itemID]:getTag();
		elseif(index == 2) then
			heroID = m_leaderHeroes[itemID]:getTag();
		elseif(index == 3) then
			heroID = m_attackerHeroes[itemID]:getTag();
		else
			heroID = m_supportedHeroes[itemID]:getTag();
		end
		if (PlayerInfo.getHeroEnabled(heroID)) then
			PlayerInfo.setQueue(index, heroID);
			changeStar(index, heroID);
		end
	else
		PlayerInfo.setQueue(index, heroID);
		changeStar(index, heroID);
	end
end

local function supportedDidScroll()
	if(m_isEquipHeroGuideFlag) then
		m_isEquipHeroGuideFlag = false;
		m_supportedHeroes[2]:removeChildByTag(10, true);
	end
end

local function scrollStopped(desc, scrollView)
	if (desc ~= "true") then
		changeQueue(scrollView:getParent():getTag(), scrollView:getContentOffset().y);
		return;
	end
	-- 对齐列表
	local posY = scrollView:getContentOffset().y;
	local offset = (-posY) % SCROLL_ITEM_DISTANCE;
	if (offset ~= 0) then
		local offsetNext = SCROLL_ITEM_DISTANCE - offset;
		if (offsetNext < offset) then
			offset = -offsetNext;
		end
		scrollView:setContentOffset(CCPoint(0, posY + offset), true);
	end
	changeQueue(scrollView:getParent():getTag(), posY + offset);

	--判断是否装备上了乔国老
	if(GameGuide.canShowUpgradeGuide()) then
		if(PlayerInfo.getQueue()[4] == 9) then
			GameGuide.setUpgradeFinsh();
			--返回按钮引导
			local par = ParticleSysManager.createParticleSimple("", ccp(77, 63), 1.3);
			par:runAction(ParticleSysManager.getRotateAction());
			m_team.back:addChild(par, 10, 10);
		end
	end
end

local function initScrollView()
	-- 设置滚动回调函数
	m_supportedLayer:registerScriptHandler(scrollStopped, 2);
	m_attackerLayer:registerScriptHandler(scrollStopped, 2);
	m_leaderLayer:registerScriptHandler(scrollStopped, 2);
	m_tankLayer:registerScriptHandler(scrollStopped, 2);

	m_supportedLayer:registerScriptHandler(supportedDidScroll, CCScrollView.kScrollViewScroll);
	-- 设置列表初始位置
	local queue = PlayerInfo.getQueue();
	local supported = m_supportedLayer:getContainer():getChildByTag(queue[4]);
	local attacker = m_attackerLayer:getContainer():getChildByTag(queue[3]);
	local leader = m_leaderLayer:getContainer():getChildByTag(queue[2]);
	local tank = m_tankLayer:getContainer():getChildByTag(queue[1]);
	m_supportedLayer:setContentOffset(CCPoint(0, -supported:getPositionY() + 950), false);
	m_attackerLayer:setContentOffset(CCPoint(0, -attacker:getPositionY() + 950), false);
	m_leaderLayer:setContentOffset(CCPoint(0, -leader:getPositionY() + 950), false);
	m_tankLayer:setContentOffset(CCPoint(0, -tank:getPositionY() + 950), false);
end

local function checkGuide()
	--强化引导
	m_guideFinishFlag = false;
	if(GameGuide.getHeroStrengFinish() == false) then
		if(GameGuide.isHeroCanStren() == true) then
			m_guideFinishFlag = true;
			local upgradeGuide1Par = ParticleSysManager.createParticleSimple("", ccp(160, 180), 1.5);
			m_leaderHeroes[1]:addChild(upgradeGuide1Par, 10, 10);
			upgradeGuide1Par:runAction(ParticleSysManager.getRotateAction());
		end
	end

	--装备人物引导
	m_isEquipHeroGuideFlag = false;
	if(GameGuide.canShowUpgradeGuide()) then
		m_isEquipHeroGuideFlag = true;
		local par = ParticleSysManager.createParticleSimple("", ccp(160, 180), 1.5);
		m_supportedHeroes[2]:addChild(par, 10, 10); --乔国老
		par:runAction(ParticleSysManager.getRotateAction());
	end
end

function removeGuide()
	if(m_guideFinishFlag) then
		m_leaderHeroes[1]:removeChildByTag(10, true);
	end
end

local function versionControl()
	if(VersionControl.getCurVersion() == VERSION_BUY_GAME) then
		tolua.cast(m_team.menu_mall, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_team.menu_mall, "CCControlButton"):setVisible(false);
		tolua.cast(m_team.menu_shop, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_team.menu_shop, "CCControlButton"):setVisible(false);
	end
end

-- 创建界面
function create()
   ccb["TeamUI"] = {};
   m_team = ccb["TeamUI"];
   m_team.backOnClick = returnToLastUI;
   m_team.shopOnClick = enterShop;
   m_team.mallOnClick = enterMall;
   m_team.unselectHero = unselectHero;
   m_team.advanceOnClick = advanceHero;

   createList();
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;

	attachListController();
	initScrollView();
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
		Confirm.setCallBackFunction(openShop, notOpenShop);
		refreshMoney();
		refreshYuanbao();
		setHeroStatus({m_supportedHeroes, m_attackerHeroes, m_leaderHeroes, m_tankHeroes});
		initStars();

		checkGuide();
		versionControl();

	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		unselectHero();
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:removeChild(m_rootLayer, false);

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
	m_team = nil;
	m_rootLayer = nil;
	ccb["TeamUI"] = nil;
	m_selectedHeroNode = nil;

	removeList();
end