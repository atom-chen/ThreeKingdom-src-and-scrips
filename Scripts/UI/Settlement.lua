module("Settlement", package.seeall)

require "SceneData"

local MISSION_COUNT = 3;
local STAR_COUNT = 3;

local m_settlement = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
-- 显示任务时间的控件
local m_missionTime = nil;
-- 显示任务数量的控件
local m_missionCount = nil;
-- 显示任务评价的控件
local m_missionStar = nil;
-- 显示获得金钱的控件
local m_gold = nil;
-- 显示获得新武将的层
local m_newHeroLayer = nil;
-- 显示获得新武将的头像
local m_newHeroHead = nil;
-- 显示获得新武将的名称
local m_newHeroName = nil;
-- 显示获得新武将的星级
local m_newHeroStar = {};
-- 显示获得新武将的攻击力
local m_newHeroAtk = nil;
-- 显示获得新武将的防御力
local m_newHeroDef = nil;
-- 显示获得新武将的血量
local m_newHeroHp = nil;
-- 显示获得新武将的技能
local m_newHeroSkill = nil;
-- 显示获得新武将的标题
-- local m_newHeroTitle = nil;

local function checkStageLock()
	if (PlayerInfo.getSceneEnabled(12) == true) then
		PlayerInfo.setStageEnabled(2, true);
	end
	if (PlayerInfo.getSceneEnabled(23) == true) then
		PlayerInfo.setStageEnabled(3, true);
	end
	PlayerInfo.saveStageInfo();
end

local function enterUI()
	UIManager.loadSceneSelectCCBI(UIManager.SETTLEMENT_ID);
end

local function restartScene()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
    Settlement.close();
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
	local sceneID = SceneData.getSceneID();
	local difficulty = SceneData.getDifficulty();
	GameManager.enterSceneFromSettlement(sceneID, difficulty);
end

local function retunToSceneSelect()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbres/heads.plist");
	Settlement.close();

	UIManager.removeSettlementCCBI();
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrames();
	AnimLoader:sharedInstance():purge();
	CCTextureCache:sharedTextureCache():purge();

	AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
	
	UIManager.loadAnimation(enterUI);
end

local function attachController()
	for i = 1, MISSION_COUNT do
		m_missionTime[i] = tolua.cast(m_settlement["time_" .. i], "CCLabelTTF");
		m_missionCount[i] = tolua.cast(m_settlement["count_" .. i], "CCLabelTTF");
		m_missionComplete[i] = tolua.cast(m_settlement["complete_" .. i], "CCLabelTTF");
	end
	for i = 1, STAR_COUNT do
		m_missionStar[i] = tolua.cast(m_settlement["star_" .. i], "CCNode");
	end
	for i = 1, 4 do
		m_newHeroStar[i] = tolua.cast(m_settlement["new_hero_star_" .. i], "CCSprite");
	end
	m_gold = tolua.cast(m_settlement["gold"], "CCLabelTTF");
	m_newHeroLayer = tolua.cast(m_settlement["new_hero_layer"], "CCLayer");
	m_newHeroHead = tolua.cast(m_settlement["new_hero_head"], "CCSprite");
	m_newHeroName = tolua.cast(m_settlement["new_hero_name"], "CCLabelTTF");
	m_newHeroAtk = tolua.cast(m_settlement["new_hero_atk"], "CCLabelTTF");
	m_newHeroDef = tolua.cast(m_settlement["new_hero_def"], "CCLabelTTF");
	m_newHeroHp = tolua.cast(m_settlement["new_hero_hp"], "CCLabelTTF");
	m_newHeroSkill = tolua.cast(m_settlement["new_hero_skill"], "CCLabelTTF");
end

local function closeNewHeroLayer()
	m_newHeroLayer:setVisible(false);
	m_newHeroLayer:unregisterScriptTouchHandler();
	Settlement.star1Action();
end

local function showNewHeroInfo(heroID)
	local heroName = PlayerInfo.getHeroName(heroID);
	local data = HeroData.getData(heroName);
	local atk = math.max(data.atk_phy, data.atk_psy);
	local def = math.max(data.def_phy, data.def_psy);
	local hp = data.hp;
	local skill = data.skill or 0;
	local quality = data.quality;
	local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(heroName .. ".png");
	m_newHeroLayer:setTouchEnabled(true);
    m_newHeroLayer:setTouchMode(1);
	m_newHeroLayer:registerScriptTouchHandler(closeNewHeroLayer, false, 1, true);
	m_newHeroLayer:setScale(0.1);
	m_newHeroLayer:setVisible(true);
	m_newHeroName:setString(TEXT[heroName]);
	m_newHeroAtk:setString("" .. atk);
	m_newHeroDef:setString("" .. def);
	m_newHeroHp:setString("" .. hp);
	m_newHeroHead:setDisplayFrame(spriteFrame);
	for i = 1, quality do
		m_newHeroStar[i]:setVisible(true);
	end

	for i = quality + 1, 4 do
		m_newHeroStar[i]:setVisible(false);
	end

	if (skill == 5) then
		m_newHeroSkill:setString(TEXT["dragon"]);
	elseif (skill == 6) then
		m_newHeroSkill:setString(TEXT["shield"]);
	elseif (skill == 7) then
		m_newHeroSkill:setString(TEXT["frost"]);
	else
		m_newHeroSkill:setString(TEXT["none"]);
	end
	local action = CCScaleTo:create(0.5, 1);
	m_newHeroLayer:runAction(action);
end

local function initInterface()

	local length = SceneData.getMissionLength();
	for i = 1, length do
		local time = SceneData.getMissionTime(i);
		local count = SceneData.getMissionCount(i);
		local isComplete = SceneData.isMissionComplete(i);
		m_missionTime[i]:setString(string.format("%.1f", time));
		m_missionCount[i]:setString("" .. count);
		m_missionComplete[i]:setVisible(isComplete);
		m_settlement["mission_" .. i]:setVisible(true);
	end
	m_gold:setString("" .. SceneData.getMoney());

	local level = SceneData.getStar();
	for i = 1, level do
		m_missionStar[i]:setVisible(false);
	end

	local heroID = SceneData.getNewHero();
	if (heroID > 0) then
		showNewHeroInfo(heroID);
		return;
	end

	Settlement.star1Action();

end

function playStarEffect()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
end

function star1Action()
	if(SceneData.getStar() >= 1) then
		local star1 = m_missionStar[1];
		star1:setVisible(true);
		local array = CCArray:create();
		array:addObject(CCScaleTo:create(0.4, 2.0));
		array:addObject(CCScaleTo:create(0.2, 1.0));
		array:addObject(CCCallFunc:create(function() Settlement.playStarEffect() end));
		array:addObject(CCCallFunc:create(function() Settlement.star2Action() end));
		star1:runAction(CCSequence:create(array));
	end
end

function star2Action()
	if(SceneData.getStar() >= 2) then
		local star2 = m_missionStar[2];
		star2:setVisible(true);
		local array = CCArray:create();
		array:addObject(CCScaleTo:create(0.4, 2.0));
		array:addObject(CCScaleTo:create(0.2, 1.0));
		array:addObject(CCCallFunc:create(function() Settlement.playStarEffect() end));
		array:addObject(CCCallFunc:create(function() Settlement.star3Action() end));
		star2:runAction(CCSequence:create(array));
	end
end

function star3Action()
	if(SceneData.getStar() >= 3) then
		local star3 = m_missionStar[3];
		star3:setVisible(true);
		local array = CCArray:create();
		array:addObject(CCScaleTo:create(0.4, 2.0));
		array:addObject(CCScaleTo:create(0.2, 1.0));
		array:addObject(CCCallFunc:create(function() Settlement.playStarEffect() end));
		star3:runAction(CCSequence:create(array));
	end
end


function create()
	ccb["Settlement"] = {};
	m_settlement = ccb["Settlement"];
	m_settlement.restartOnClick = restartScene;
	m_settlement.endOnClick = retunToSceneSelect;
	m_missionTime = {};
	m_missionCount = {};
	m_missionComplete = {};
	m_missionStar = {};
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
	attachController();
end

-- 打开界面
function open()
	checkStageLock();
	SceneManager.saveSceneInfo();--保存场景信息

	if (not m_isOpen) then
		m_isOpen = true; 
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		initInterface();
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
	m_settlement = nil;
	m_rootLayer = nil;
	ccb["Settlement"] = nil;
	m_missionTime = nil;
	m_missionCount = nil;
	m_missionComplete = nil;
	m_missionStar = nil;
end