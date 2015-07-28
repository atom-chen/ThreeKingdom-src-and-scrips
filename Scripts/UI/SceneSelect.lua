module("SceneSelect", package.seeall)

local STAGE_COUNT = 3;
local SCENE_COUNT_IN_STAGE = 11;
local HERO_COUNT = 4;

local BG_NAME = {"Village.pvr.ccz", "city.pvr.ccz", "Outsidevillage.pvr.ccz"};
local SCENE_ICON = {
		{1, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4},
		{2, 2, 3, 3, 4, 3, 3, 1, 1, 1, 2},
		{4, 3, 4, 3, 2, 2, 3, 1, 3, 4, 1}
};

-- 保存界面所有变量的表
local m_sceneSelect = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
-- 大关卡
local m_stages = nil;
-- 大关卡索引号
local m_stageIndex = nil;
-- 主角图标
local m_heroes = nil;
-- 小关卡滚动列表
local m_sceneList = nil;

-- 关卡星级
local m_scrollLayer = nil;
local m_sceneScrollView = nil;
local m_sceneStar = nil;
local m_sceneCycles = nil;

local m_curStage = 1;

local m_touchFlag = 0;

local m_hasGuide = false;
local m_hasUpgradeGuide = false;

-- 按钮回调事件，自定义
local function returnToMainMenu()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	SceneSelect.close();

	UIManager.removeSceneSelectCCBI();
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

	UIManager.loadMainMenuCCBI();
end

--设置最后一关
local function setSceneVisible(sceneOffset, index, isVisible)
	local button = tolua.cast(m_scrollLayer:getChildByTag(index), "CCControlButton");
	button:setVisible(isVisible);
	if (index == 11) then
		m_sceneScrollView.number_11_1:setVisible(isVisible);
		m_sceneScrollView.number_11_2:setVisible(isVisible);
	end
	
	if (isVisible == true) then
		local starCount = PlayerInfo.getSceneStar(sceneOffset + index);
		for i = 1, starCount do
			m_sceneStar[index][i]:setVisible(true);
		end
		for i = starCount + 1, SCENE_STAR_MAX do
			m_sceneStar[index][i]:setVisible(true);
		end
	else
		for i, star in ipairs(m_sceneStar[index]) do
			star:setVisible(true);
		end
	end
end

local function setStageEnable()
	for i = 1, STAGE_COUNT do
		local isEnabled = PlayerInfo.getStageEnabled(i);
		tolua.cast(m_sceneSelect["stage_" .. i], "CCControlButton"):setEnabled(isEnabled);
	end
end

--设置此大关的每一小关的图标显示
local function setSceneIcons(stage)
	local frontName = "guanka_" .. stage .. "_";
	local sceneOffset = (stage - 1) * SCENE_COUNT_IN_STAGE;
	--循环此大关的每一小关
	for i = 1, SCENE_COUNT_IN_STAGE do
		--按钮
		local button = tolua.cast(m_scrollLayer:getChildByTag(i), "CCControlButton");
		local fileName = frontName .. SCENE_ICON[stage][i] .. ".png";
		local disName = "guanka-" .. SCENE_ICON[stage][i] .. "-lock.png";
		local imgNormal = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(fileName);
		local imgDis = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(disName);
		button:setBackgroundSpriteFrameForState(imgNormal, CCControlStateNormal);
		button:setBackgroundSpriteFrameForState(imgNormal, CCControlStateHighlighted);
		button:setBackgroundSpriteFrameForState(imgDis, CCControlStateDisabled);
		--星星、皇冠
		local starCount = PlayerInfo.getSceneStar(sceneOffset + i);
		for j = 1, starCount do
			m_sceneStar[i][j]:setVisible(true);
		end
		for j = starCount + 1, SCENE_STAR_MAX do
			m_sceneStar[i][j]:setVisible(false);
		end
		--光圈
		m_sceneCycles[i]:setVisible(PlayerInfo.getSceneNew(sceneOffset + i));
	end
end

local function setSceneEnable(stage)
	local sceneOffset = (stage - 1) * SCENE_COUNT_IN_STAGE;
	for i = 1, 10 do
		local button = tolua.cast(m_scrollLayer:getChildByTag(i), "CCControlButton");
		button:setEnabled(PlayerInfo.getSceneEnabled(sceneOffset + i));
	end
	setSceneVisible(sceneOffset, 11, PlayerInfo.getSceneEnabled(sceneOffset + 11));
end

local function changeBackground(stage)
	local bg = tolua.cast(m_sceneSelect.bg_far, "CCSprite");
	bg:setScale(2);
	local fileName = PATH_CCB_ROOT .. BG_NAME[stage];
	local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
	bg:setTexture(texture);
end

local function switchStage(desc, button)
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	local stage = m_stageIndex[button];
	if (m_curStage == stage) then
		return;
	end

	changeBackground(stage);

	setSceneIcons(stage);
	setSceneEnable(stage);
	m_curStage = stage;
end

local function enterHeroInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);

	if(m_hasGuide) then
		m_sceneSelect.head_2:removeChildByTag(10, true);
		m_hasGuide = false;
	end

	if(m_hasUpgradeGuide) then
		m_sceneSelect.head_4:removeChildByTag(10, true);
		m_hasUpgradeGuide = false;
	end

	SceneSelect.close();

	UIManager.removeSceneSelectCCBI();
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
	CCTextureCache:sharedTextureCache():removeUnusedTextures();


	UIManager.loadTeamCCBI(UIManager.SCENESELECT_ID);
end

local function entershopInterface()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	SceneSelect.close();

	UIManager.removeSceneSelectCCBI();
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
	CCTextureCache:sharedTextureCache():removeUnusedTextures();

	UIManager.loadRechargeCCBI();
end

local function enterToMall()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    SceneSelect.close();

    UIManager.removeSceneSelectCCBI();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();

    UIManager.loadMallCCBI();
end

local function selectScene(desc, button)
	if(m_touchFlag ~= 1) then
		AudioEngine.playEffect(UIManager.PATH_EFFECT_NEWPOINTS, false);
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
		local index = tolua.cast(button, "CCNode"):getTag();
		
		local sceneID = (m_curStage - 1) * SCENE_COUNT_IN_STAGE + index;
		local difficulty = 1;
		if (PlayerInfo.getSceneNew(sceneID)) then
			difficulty = 2;
		end
		AudioEngine.stopMusic(false);
		-- PlayerInfo.setSceneNew(sceneID, false);
		SceneSelect.close();

		UIManager.turnToScene(sceneID, difficulty);
	end
end

local function createSceneList()
	ccb["SceneList"] = {};
	m_sceneScrollView = ccb["SceneList"];
	m_sceneScrollView.sceneOnClick = selectScene;

	m_sceneStar = {};
	m_sceneCycles = {};
end

local function attachControllers()
	for i = 1, STAGE_COUNT do
		m_stages[i] = tolua.cast(m_sceneSelect["stage_" .. i], "CCControlButton");
		m_stageIndex[m_stages[i]] = i;
	end

	for i = 1, HERO_COUNT do
		m_heroes[i] = tolua.cast(m_sceneSelect["head_" .. i], "CCControlButton");
	end

	m_sceneList = tolua.cast(m_sceneSelect.sceneList, "CCScrollView");
end

local function attachListControllers()
	for i = 1, SCENE_COUNT_IN_STAGE do
		m_sceneStar[i] = {};
		--星星
		for j = 1, 3 do
			m_sceneStar[i][j] = tolua.cast(m_sceneScrollView["star_" .. i .. "_" .. j], "CCNode");
		end
		--皇冠
		m_sceneStar[i][4] = tolua.cast(m_sceneScrollView["ic-" .. i .. "-2"], "CCNode");
		m_sceneStar[i][5] = tolua.cast(m_sceneScrollView["ic-" .. i .. "-1"], "CCNode");
		--光圈
		m_sceneCycles[i] = tolua.cast(m_sceneScrollView["cycle_" .. i], "CCSprite");
	end

	m_scrollLayer = m_sceneList:getContainer();
end

local function removeSceneList()
	m_sceneStar = nil;
	m_sceneCycles = nil;
end

local function showHeroButton()
	local heroes = PlayerInfo.getQueue();
	for i = 1, HERO_COUNT do
		local isExist = (heroes[i] > 0);
		m_heroes[i]:setVisible(isExist);
		if (isExist == true) then
			local name = PlayerInfo.getHeroName(heroes[i]) .. ".png";
			local image = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name);
			m_heroes[i]:setBackgroundSpriteFrameForState(image, CCControlStateNormal);
			m_heroes[i]:setBackgroundSpriteFrameForState(image, CCControlStateHighlighted);
			-- m_heroes[i]:setBackgroundSpriteFrameForState(image, CCControlStateDisabled);
		end
	end
end

local function boundStarsToButton()
	for i = 1, SCENE_COUNT_IN_STAGE do
		local pointBtn = tolua.cast(m_sceneScrollView["pointBtn_" .. i], "CCControlButton");
		pointBtn:setTag(i);
		--星星
		for j = 1,3 do
			local star = tolua.cast(m_sceneScrollView["star_" .. i .. "_" .. j], "CCSprite");
			star:removeFromParentAndCleanup(false);
			pointBtn:addChild(star, 1);
			if(j == 1) then
				star:setPosition(ccp(98.8, 115));
			end
			if(j == 2) then
				star:setPosition(ccp(153.5, 94.2));
			end
			if(j == 3) then
				star:setPosition(ccp(209.7, 118.7));
			end
		end
		--数字
		if(i < 10) then
			local num = tolua.cast(m_sceneScrollView["number_" .. i], "CCSprite");
			num:removeFromParentAndCleanup(false);
			num:setPosition(ccp(153, 212.5));
			pointBtn:addChild(num, 1);
		else
			local num1 = tolua.cast(m_sceneScrollView["number_" .. i .. "_1"], "CCSprite");
			local num2 = tolua.cast(m_sceneScrollView["number_" .. i .. "_2"], "CCSprite");
			num1:removeFromParentAndCleanup(false);
			num2:removeFromParentAndCleanup(false);
			num1:setPosition(ccp(143, 212.5));
			num2:setPosition(ccp(163, 212.5));
			pointBtn:addChild(num1, 1);
			pointBtn:addChild(num2, 1);
		end
		--皇冠
		for z = 1,2 do
			local hat = tolua.cast(m_sceneScrollView["ic-" .. i .. "-" .. z], "CCSprite");
			hat:removeFromParentAndCleanup(false);
			pointBtn:addChild(hat, 1);
			if(z == 1) then
				hat:setPosition(ccp(64.3, 201.2));
			else
				hat:setPosition(ccp(240.4, 201.2));
			end
		end
	end
end

local function refreshMoney()
	local money = PlayerInfo.getMoney();
	tolua.cast(m_sceneSelect.money, "CCLabelTTF"):setString("" .. money);
end

local function refreshYuanbao()
	local yuanbao = PlayerInfo.getToken();
	tolua.cast(m_sceneSelect.yuanbao, "CCLabelTTF"):setString("" .. yuanbao);
end

local function scrollViewDidScroll()
    if( tolua.cast(m_sceneSelect["sceneList"], "CCScrollView"):isTouchMoved() ) then
    	m_touchFlag = 1;
    else
		m_touchFlag = 0;
    end
end

local function registerScrollViewTouchHander()
	local slv = tolua.cast(m_sceneSelect["sceneList"], "CCScrollView");
	slv:registerScriptHandler(scrollViewDidScroll, CCScrollView.kScrollViewScroll);
end

local function unregisterScrollViewTouchHander()
	local slv = tolua.cast(m_sceneSelect["sceneList"], "CCScrollView");
	slv:unregisterScriptHandler(CCScrollView.kScrollViewScroll);
	m_touchFlag = 0;
end

local function checkGuide()
	--强化引导
	m_hasGuide = false;
	if(GameGuide.getHeroStrengFinish() == false)then
		if(GameGuide.isHeroCanStren()) then
			m_hasGuide = true;
			local head_2 = tolua.cast(m_sceneSelect.head_2, "CCNode");
			local particle = ParticleSysManager.createParticleSimple("", ccp(109, 107), 1.3);
			head_2:addChild(particle, 10, 10);
			particle:runAction(ParticleSysManager.getRotateAction());
		end
	end
	--装备人物引导
	m_hasUpgradeGuide = false;
	if(GameGuide.canShowUpgradeGuide() == true) then
		m_hasUpgradeGuide = true;
		local head_4 = tolua.cast(m_sceneSelect.head_4_bg, "CCNode");
		local par = ParticleSysManager.createParticleSimple("", ccp(109, 107), 1.3);
		head_4:addChild(par, 10, 10);
		par:runAction(ParticleSysManager.getRotateAction());
	end
end

local function versionControl()
	if(VersionControl.getCurVersion() == VERSION_BUY_GAME) then
		tolua.cast(m_sceneSelect.menu_mall, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_sceneSelect.menu_mall, "CCControlButton"):setVisible(false);
		tolua.cast(m_sceneSelect.menu_shop, "CCControlButton"):setTouchEnabled(false);
		tolua.cast(m_sceneSelect.menu_shop, "CCControlButton"):setVisible(false);
	end
end


-- 创建界面
function create()
	ccb["SceneSelect"] = {};
	m_sceneSelect = ccb["SceneSelect"];
	m_sceneSelect.mainMenuOnClick = returnToMainMenu;
	m_sceneSelect.stageOnClick = switchStage;
	m_sceneSelect.heroOnClick = enterHeroInterface;
	m_sceneSelect.shopOnClick = entershopInterface;
	m_sceneSelect.mallOnClick = enterToMall;

	m_stages = {};
	m_heroes = {};
	m_stageIndex = {};

	createSceneList();
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;

	attachControllers();
	attachListControllers();
	boundStarsToButton();

	changeBackground(m_curStage);
	setSceneIcons(m_curStage);	


	registerScrollViewTouchHander();
end

-- 打开界面
function open(ui)
	if (not m_isOpen) then
		m_isOpen = true;
		if(ui == UIManager.SETTLEMENT_ID or ui == UIManager.ZHANDOU_ID) then
			AudioEngine.playMusic(PATH_RES_AUDIO .. "bg.mp3", true);
		end
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		-- 显示主角图标
		showHeroButton();
		setStageEnable();
		setSceneEnable(m_curStage);
		refreshMoney();
		refreshYuanbao();

		checkGuide();
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
		unregisterScrollViewTouchHander();
		m_rootLayer:removeAllChildrenWithCleanup(true);
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
	end
	m_isOpen = false;
	m_sceneSelect = nil;
	m_rootLayer = nil;
	ccb["SceneSelect"] = nil;

	m_stages = nil;
	m_heroes = nil;
	m_stageIndex = nil;

	removeSceneList();

end