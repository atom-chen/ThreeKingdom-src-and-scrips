module("SceneManager", package.seeall)

require "MOV"
require "ATK"
require "EFF"
require "SkillData"
require "Buff"
require "MissionData"
require "AlertCalc"
require "Collision"
require "SceneUI"
require "SceneData"
require "PauseInterface"
require "FailInterface"

local m_tempData = nil;

local m_sceneID;
local m_bgList = nil;
local m_bgSpeed = nil;
local m_actors = nil;
local m_events = nil;
local m_speed = 0;
local m_curAngle = 0;
local m_curIndex = 0;
local m_angleMax = 0;
local m_backIndex = 0;

local m_eventCreateCount = 1;
local m_removeEventPool = nil;

local m_processObserver = nil;
local m_skillObserver = nil;

local m_missions = nil;
local m_missionTime = nil;

local m_eventCreateName = nil;

local m_difficulty = 1;

local m_winCB = nil;
local m_isWin = false;

local m_skillMission = false;
local SCENE_COUNT_IN_STAGE = 11;

local m_sceneMusic = {
	1,2,3,4,5,6,
	1,2,3,4,5,6,
	1,2,3,4,5,6,
	1,2,3,4,5,6,
	1,2,3,4,5,6,
	1,2,3
};

function skillObservation(skillType)
	for observer, aSkill in pairs(m_skillObserver) do
		if (skillType == aSkill) then
			m_skillMission = true;
			observer:active();
		end
	end
end

local function gestureObser(message, gestureID)
	local skillIndex = SkillData.getSkillIndex(gestureID:getValue());
	local skillType = HeroManager.useSkill(skillIndex);
	skillObservation(skillType);
end

local function createActorInfo(dict)
	local aType = tolua.cast(dict:objectForKey("type"), "CCString");
	local angle = tolua.cast(dict:objectForKey("angle"), "CCFloat");
    local height = tolua.cast(dict:objectForKey("height"), "CCFloat");
    local res = tolua.cast(dict:objectForKey("res"), "CCString");
    local z = tolua.cast(dict:objectForKey("z"), "CCInteger");
    local flip = tolua.cast(dict:objectForKey("flip"), "CCBool");
    local actor = {};
    actor["type"] = aType:getCString();
    actor["angle"] = angle:getValue();
    actor["height"] = height:getValue();
    actor["res"] = res:getCString();
    actor["z"] = z:getValue();
    actor["flip"] = flip:getValue();

    local eventName = dict:objectForKey("event");
    if (eventName) then
    	local event = tolua.cast(eventName, "CCString");
    	actor["event"] = event:getCString();
    end
    return actor;
end

local function insertActorByAngle(actor)
	local isInsert = false;
	local count = #m_actors;
    for j = 1, count do
	    if (actor["angle"] < m_actors[j]["angle"]) then
	        table.insert(m_actors, j, actor);
	        isInsert = true;
	        break;
	    end
	end
	if (not isInsert) then
        table.insert(m_actors, actor);
    end
end

local function loadSceneLength(sds)
	m_angleMax = sds:getSceneLength();
end

local function loadActorsInfo(sds)
	local dataSet = tolua.cast(sds:getAllActors(), "CCArray");
    local count = dataSet:count();
    for i = 1, count do
        local dict = tolua.cast(dataSet:objectAtIndex(i - 1), "CCDictionary");
        local actor = createActorInfo(dict);
        insertActorByAngle(actor);
    end
end

local function createHeroes()
	HeroManager.init();

	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);

	local heroes = PlayerInfo.getQueue();
	local x = TEAM_FIRST_POS;
	for i = 1, #heroes do
		if (heroes[i] > 0) then
			local heroName = PlayerInfo.getHeroName(heroes[i]);
			local heroLevel = PlayerInfo.getHeroLevel(heroes[i]);
			local resName = heroName;
			if (heroLevel > 0) then
				heroName = heroName .. "_" .. heroLevel;
			end
			local heroLua = HeroManager.createHero(heroName, resName, 0, x, false);
			HeroManager.doBehavior(heroLua, "walk");
			local actor = heroLua["actor"];
			mainLayer:addChild(tolua.cast(actor, "CCNode"), HERO_Z);
			x = x - DISTANCE_BETWEEN_HEROES;
		end
	end
    
    HeroManager.calcLeaderIndex(heroes[1] > 0);

    HeroManager.calcHpTotal();
    HeroManager.calcDefTotal();

end

local function playSceneMusic()
	--根据 sceneID（也就是场景tag）播放相应的背景音乐
	AudioEngine.playMusic(PATH_RES_AUDIO .. "bg_" .. m_sceneMusic[m_sceneID] .. ".mp3", true);
end

local function readyToRun()
	loadSceneLength(SceneDataSource:sharedInstance());
    loadActorsInfo(SceneDataSource:sharedInstance());

    createHeroes();

    HeroManager.Recovery();

    local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
    mainLayer:scheduleUpdateWithPriorityLua(update, 1);
    mainLayer:setTouchEnabled(true);
    mainLayer:setTouchMode(1);
	mainLayer:registerScriptTouchHandler(touchEvent, false, 0, false);

	local touchLayer = TouchGesture:create((PATH_RES_DATA .. "duiyingCanshu.plist"), gestureObser);
	addSceneLayer(touchLayer, 2, SCENE_TOUCH_LAYER);

	local leaderName = HeroManager.getLeaderName();
	SceneUI.create(leaderName);
	SceneUI.setMissionDesc("? ? ?");
	SceneUI.setMissionNumberCur("?");
	SceneUI.setMissionNumberMax("?");

	Loading.remove();
	playSceneMusic();
end

local function loadOtherResources()
	AnimLoader:sharedInstance():setPath(PATH_RES_OTHER);

	local touch = {resType = LOADING_TYPE_ANIM, resName = "dianji"};
	local resList = {touch};

	Loading.create(resList, readyToRun);
end

local function loadEmotionResources()
	AnimLoader:sharedInstance():setPath(PATH_RES_EMOTION);

	local tanhao = {resType = LOADING_TYPE_ANIM, resName = "tanhao"};
	local dialog = {resType = LOADING_TYPE_ANIM, resName = "duihuakuang"};
	local effect = {resType = LOADING_TYPE_ANIM, resName = "wupinguang"};
	local resList = {tanhao, dialog, effect};

	-- Loading.create(resList, loadOtherResources);
	Loading.create(resList, readyToRun);
end

local function loadHeroResources()
	AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);

	local resList = {};

	local heroes = PlayerInfo.getQueue();
	for i, heroIndex in ipairs(heroes) do
		if (heroIndex > 0) then
			local data = {resType = LOADING_TYPE_ANIM, resName = PlayerInfo.getHeroName(heroIndex)};
			table.insert(resList, data);
		end
	end

	Loading.create(resList, loadEmotionResources);
end

local function loadActorResources()
	local resList = {};

	local dataSet = SceneDataSource:sharedInstance():getAllResources();
    AnimLoader:sharedInstance():setPath(PATH_RES_ACTORS);

    local count = dataSet:count();
    for i = 1, count do
    	local resName = tolua.cast(dataSet:objectAtIndex(i - 1), "CCString");
    	local data = {resType = LOADING_TYPE_ANIM, resName = resName:getCString()};
    	table.insert(resList, data);
    end

    Loading.create(resList, loadHeroResources);
end

local function createBackground(sceneID)
	local mapData = MapData.getData(sceneID);

	local bgLayer = getSceneLayer(SCENE_BG_LAYER);
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);

 	local bg = CCLayerColor:create(ccc4(224, 242, 242, 255));
 	bg:setContentSize(CCSize(SCREEN_WIDTH, SCREEN_HEIGHT));
 	bgLayer:addChild(bg);

    local fog = CCSprite:create(PATH_RES_MAPS .. "fog.pvr.ccz");
    fog:setPosition(CCPoint(0, 0));
    fog:setAnchorPoint(CCPoint(0, 0));
    fog:setScale(2);
    mainLayer:addChild(fog, -9);

    for i, layerData in ipairs(mapData) do
    	local resName = PATH_RES_MAPS .. layerData.tile .. ".pvr.ccz";
    	local arcBg = ArcBackground:create(resName, layerData.height, layerData.distance, layerData.scale);
    	arcBg:setRotation(layerData.angle);
    	mainLayer:addChild(tolua.cast(arcBg, "CCNode"), layerData.z);
    	m_bgList[i] = arcBg;
    	m_bgSpeed[i] = layerData.speed;
    end
end

function rotateScene()
	for i, bgLayer in ipairs(m_bgList) do
		bgLayer:start();
	end
end

function stopScene()
	for i, bgLayer in ipairs(m_bgList) do
		bgLayer:stop();
	end
end

function setSpeed(speed)
	for i, bgLayer in ipairs(m_bgList) do
		bgLayer:setSpeed(speed * m_bgSpeed[i]);
	end
end

function getMissionTime()
	if (m_missions == null or #m_missions == 0) then
		return 0, 0;
	end
	local curTime = m_missionTime[#m_missionTime];
	local timeMax = m_missions[#m_missions]:getTimeLimit();
	return curTime, timeMax;
end

local function removeEvent(eventName)
	local event = m_events[eventName];
	if (event) then
		SceneEvent:remove(event);
		m_events[eventName] = nil;
	end
end

local function createEvent(eventName, actor)
	if (eventName == nil or eventName == "" or eventName == "0") then
		return;
	end

	if (m_events[eventName]) then
		removeEvent(eventName);
	end
	m_events[eventName] = SceneEvent:create(eventName, tolua.cast(actor, "CCObject"));
end

local function removeAllEvents()
	for key, event in pairs(m_events) do
		removeEvent(key);
	end
	m_events = nil;
end

function registerRemoveEvent(eventName, actor)
	table.insert(m_removeEventPool, eventName);
	ActorManager.setInvalid(actor);
end

local function getMissionBonus(mission)
	local missionType = mission:getType();
	local money, score, star = MissionData.getBonus(missionType);
	PlayerInfo.modifyMoney(money);
	PlayerInfo.modifyScore(score);
	SceneData.modifyStar(star);
	SceneData.modifyMoney(money);
end

function createMission(missionType)
	missionType = "l" .. m_sceneID .. "_" .. missionType;
	local mission = Mission:create(missionType);
	table.insert(m_missions, mission);
	table.insert(m_missionTime, 0);
	local desc = MissionData.getDesc(missionType);

	SceneUI.timeBarNoBlink();
	SceneUI.setMissionDesc(desc);
	SceneUI.setMissionNumberCur(0);
	SceneUI.setHatVisible(false);
	SceneData.addAMission();
	HeroManager.recoverPercent(0.5);
end

function removeMission()
	table.remove(m_missions);
	table.remove(m_missionTime);
	if (#m_missions > 0) then
		local mission = m_missions[#m_missions];
	end
end

function addMissionCount(countType)
	local index = #m_missions;
	local mission = m_missions[index];
	if (mission == nil) then
		return;
	end
	countType = "l" .. m_sceneID .. "_" .. countType;
	mission:addCount(1, countType);
	SceneUI.setMissionNumberCur(mission:getCount());
	SceneData.setMissionCount(mission:getCount());
	if (mission:isComplete()) then
		getMissionBonus(mission);
		HeroManager.delItemFromLeader();
		SceneData.calcMissionTime(m_missionTime[index]);
		SceneData.missionComplete();
		SceneUI.setHatVisible(true);
		SceneUI.hatBlink(); --皇冠缩放效果
		removeMission();
		if (m_skillMission ~= true) then
			HeroManager.doVictoryBehavior();
		else
			m_skillMission = false;
		end
	else
		SceneUI.setHatVisible(false);
	end
end

function setMissionTime(desc, time)
	local mission = m_missions[#m_missions];
	local timeValue = time:getValue();
	mission:setTimeLimit(timeValue);
	m_missionTime[#m_missionTime] = timeValue;
	SceneData.setMissionTimeMax(timeValue);
end

function setMissionCount(desc, count)
	local mission = m_missions[#m_missions];
	local value = count:getValue();
	mission:setCountMax(value);
	SceneUI.setMissionNumberMax(value);
end

local function removeAllMissions()
	for i, mission in ipairs(m_missions) do
		mission:remove();
	end
	m_missions = nil;
	m_missionTime = nil;
end

local function activeHero(heroName)
	local heroID = PlayerInfo.getHeroID(heroName);
	SceneData.setNewHero(heroID);
	PlayerInfo.setHeroEnabled(heroID, true);
	DocManager.saveBool("hero_enable_" .. heroID, true);
	DocManager.flush();
end

local function initScene(sceneID)
	m_sceneID = sceneID;
	m_speed = 0;
	m_curAngle = 0;
	m_angleMax = 0;
	m_curIndex = 1;
	m_backIndex = 0;
	m_isWin = false;
	m_bgList = {};
	m_bgSpeed = {};
	m_actors = {};
	m_events = {};
	m_processObserver = {};
	m_removeEventPool = {};
	m_skillObserver = {};
	m_eventCreateCount = 1;
	m_missions = {};
	m_missionTime = {};
	m_skillMission = false;
end

local function freeAll()
	HeroManager.removeAllHeroes();
	ActorManager.removeAllActors();
	EffectManager.removeAllActors();
	removeAllEvents();
	removeAllMissions();
	m_bgList = nil;
	m_bgSpeed = nil;
	m_actors = nil;
	m_processObserver = nil;
	m_removeEventPool = nil;
	m_skillObserver = nil;
	m_eventCreateName = nil;
	m_winCB = nil;
end

local function setEventHandler(seLoader)
	seLoader:setProcessHandler(registerProcessObserver);
	seLoader:setDelProcessHandler(unregisterProcessObserver);
	seLoader:setCreateEventHandler(createEvent);
	seLoader:setRemoveEventHandler(registerRemoveEvent);
	seLoader:setDoBehaviorHandler(ActorManager.doActorBehavior);
	seLoader:setCreateActorHandler(createActorEvent);
	seLoader:setCreateCountHandler(setCreateCount);
	seLoader:setRandomCountHandler(randomCreateCount);
	seLoader:setCreateMissionHandler(createMission);
	seLoader:setMissionTimeHandler(setMissionTime);
	seLoader:setMissionCountHandler(setMissionCount);
	seLoader:setRemoveMissionHandler(removeMission);
	seLoader:setAddMissionCountHandler(addMissionCount);
	seLoader:setModifyHPHandler(HeroManager.modifyHP);
	seLoader:setGiveMoneyHandler(giveMoney);
	seLoader:setWinHandler(win);
	seLoader:setSkillHandler(registerSkillObserver);
	seLoader:setDelSkillHandler(unregisterSkillObserver);
	seLoader:setActiveSceneHandler(activeScene);
	seLoader:setEmotionHandler(ActorManager.setEmotion);
	seLoader:setDialogHandler(ActorManager.setDialog);
	seLoader:setEventCreateHandler(setCreateEvent);
	seLoader:setAddItemHandler(HeroManager.addItemToLeader);
	seLoader:setDelItemHandler(HeroManager.delItemFromLeader);
	seLoader:setAttachItemCountTargetHandler(HeroManager.setLeaderTargetForCondition);
	-- seLoader:getSetInvalidHandler(ActorManager.setInvalid);
	seLoader:setActiveHeroHandler(activeHero);
end

function preLoadSceneMusic()
	AudioEngine.preloadMusic(PATH_RES_AUDIO .. "bg_" .. m_sceneMusic[m_sceneID] .. ".mp3");
end

function enterScene(sceneID, difficulty, winCB, existRes)
	initScene(sceneID);
	m_difficulty = difficulty;
	m_winCB = winCB;
	
	SceneData.resetData();
    SceneData.setSceneID(sceneID);
    SceneData.setDifficulty(difficulty);
    preLoadSceneMusic();
    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888);

	setEventHandler(SceneEventLoader:sharedInstance());


	local resList = EffectManager.getResources();
	local leaderName = HeroManager.getLeaderName();
	local effectName = leaderName .. "dazhao";

	local effect = {resType = LOADING_TYPE_ANIM, resName = effectName};
	local effect2 = {resType = LOADING_TYPE_ANIM, resName = effectName .. "2"};
	local event = {resType = LOADING_TYPE_EVENT, resName = PATH_RES_EVENTS .. "event_" .. sceneID .. ".json"};
	local scene = {resType = LOADING_TYPE_SCENE, resName = PATH_RES_SCENES .. "scene_" .. sceneID .. ".json"};
	local tiles = {resType = LOADING_TYPE_TILE, resName = sceneID};

	table.insert(resList, effect);
	table.insert(resList, effect2);
	table.insert(resList, event);
	table.insert(resList, scene);
	table.insert(resList, tiles);

	if (sceneID == 10 or sceneID == 28) then
		table.insert(resList, {resType = LOADING_TYPE_ANIM, resName = "zhangjiao1"});
		table.insert(resList, {resType = LOADING_TYPE_ANIM, resName = "zhangjiao2"});
	elseif (sceneID == 21) then
		table.insert(resList, {resType = LOADING_TYPE_ANIM, resName = "lvbu1_2"});
	elseif (sceneID == 32) then
		table.insert(resList, {resType = LOADING_TYPE_ANIM, resName = "lvbu1_3"});
	end

	local onLoadingEnd = nil;
	if (existRes ~= true) then
	    onLoadingEnd = loadActorResources;
	else
		onLoadingEnd = readyToRun;
	end

	Loading.create(resList, onLoadingEnd);

end

function exitScene()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	AudioEngine.stopMusic(false);

	local bgLayer = getSceneLayer(SCENE_BG_LAYER);
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
	local touchLayer = getSceneLayer(SCENE_TOUCH_LAYER);

	mainLayer:unscheduleUpdate();
	mainLayer:unregisterScriptTouchHandler();
	SceneUI.remove();
	touchLayer:removeFromParentAndCleanup(true);

	freeAll();

	bgLayer:removeAllChildrenWithCleanup(true);
	mainLayer:removeAllChildrenWithCleanup(true);
	if(not PlayerInfo.getSceneNew(m_sceneID)) then
		DocManager.saveBool("scene_isNew_" .. m_sceneID, false);
	end
end

function setInvalid(actorLua)
	local id = actorLua.id;
	if (id) then
		m_actors[id]["invalid"] = true;
	end
end

local function createNewActor(idx, index)
	local actor = m_actors[idx];
	local actorType = actor["type"];
	local res = actor["res"];
	local angle = actor["angle"];
	local height = actor["height"];
	local z = actor["z"];
	local flip = actor["flip"];
	local event = actor["event"];
	
	local newActor, id = ActorManager.createActor(actorType, res, height, 0, angle - m_curAngle, flip, index);
	newActor.id = idx;
	newActor.hp = newActor.hp * m_difficulty;
	newActor.hp_max = newActor.hp_max * m_difficulty;
	newActor.atk_phy = newActor.atk_phy * m_difficulty;
	newActor.atk_psy = newActor.atk_psy * m_difficulty;
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
	mainLayer:addChild(tolua.cast(newActor["actor"], "CCNode"), z);
	if (actor["invalid"] == true) then
		newActor.speed_x = 0;
		newActor.speed_y = 0;
		newActor.a_x = 0;
		newActor.a_y = 0;
		newActor.timer = 0;
		newActor["behavior"] = "die";
		ActorManager.onDie(newActor);
		return;
	else
		ActorManager.doBehavior(newActor, "stand");
		createEvent(event, newActor["actor"]);
	end
end

local function ProcessObservation()
	local offsetAngle = HeroManager.getLeaderAngle();
	for observer, process in pairs(m_processObserver) do
		if (m_curAngle + offsetAngle >= process) then
			observer:active();
		end
	end
end

local function processForward()
	local count = #m_actors;
	for i = m_curIndex, count do
		local actor = m_actors[i];
		if (m_curAngle + SCENE_VISION < actor["angle"]) then
			break;
		else
			createNewActor(i);
			m_curIndex = m_curIndex + 1;
		end
	end
end

local function processBack()
	local count = m_backIndex;
	for i = 1, count do
		local actor = m_actors[count - i + 1];
		if (m_curAngle - SCENE_VISION > actor["angle"]) then
			break;
		else
			createNewActor(count - i + 1, 1);
			m_backIndex = m_backIndex - 1;
		end
	end
end

local function checkProcess(angle)
	local isLock = false;
	m_curAngle = m_curAngle + angle;
	if (m_curAngle >= m_angleMax) then
		isLock = true;
	end

	ProcessObservation();

	if (isLock == false) then
		if (angle > 0) then
			processForward();
		elseif (angle < 0) then
			processBack();
		end
	end
end

function modifyCurIndex(value)
	m_curIndex = m_curIndex + value;
end

function modifyBackIndex(value)
	m_backIndex = m_backIndex + value;
end

local function missionFailed()
	removeMission();
end

local function updateMission(time)
	if (#m_missions == 0) then
		return;
	end
	local mission = m_missions[#m_missions];
	local timeLimt = mission:getTimeLimit();
	if (timeLimt > 0) then
		local index = #m_missionTime;
		m_missionTime[index] = m_missionTime[index] - time;
		if(SceneUI.getIsTimeBarBlink() ~= true) then
			if(m_missionTime[index] <= 10)then
				SceneUI.timeBarBlink(m_missionTime[index], m_missionTime[index] / 0.3);
			end
		elseif (m_missionTime[index] <= 0) then
			missionFailed();
		end
	end
end

--任务完成，计算打星数量
local function calcStarCount()
	local record = PlayerInfo.getSceneStar(m_sceneID);
	local star = SceneData.getStar();
	if (m_difficulty > 1) then
		if (star >= 2) then
			star = star + 2;
		end
	end
	PlayerInfo.modifySceneStar(m_sceneID, math.max(star, record) - record);
end

function update(time)
	local angle = time * m_speed;
	local speed = m_speed;
	local actors = ActorManager.getActors();
	local heroes = HeroManager.getHeroes();
	local effects = EffectManager.getEffects();
	local isGameOver = false;

	if (m_isWin == true) then
		calcStarCount();
		m_winCB(UI_TYPE_SCENE_LOOT);
		return;
	end
	
	checkProcess(angle);
	
	if (m_removeEventPool and #m_removeEventPool > 0) then
		for i, eventName in ipairs(m_removeEventPool) do
			removeEvent(eventName);
		end
		m_removeEventPool = {};
	end

	AlertCalc.checkAlert(heroes, actors);
	ActorManager.update(time, angle);
	m_speed, isGameOver = HeroManager.update(time, m_curAngle, m_angleMax);
	EffectManager.update(time, angle);
	Collision.checkCollision(heroes, actors, effects);
	
	updateMission(time);

	if (isGameOver == true) then
		local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
		local uiLayer = getSceneLayer(SCENE_UI_LAYER);
		mainLayer:unscheduleUpdate();
		mainLayer:onExit();
		uiLayer:onExit();
		FailInterface.create();
		return;
	end

	if (m_speed ~= speed) then
		if (speed == 0) then
			setSpeed(m_speed);
			rotateScene();
		elseif (m_speed == 0) then
			stopScene();
		else
			setSpeed(m_speed);
		end
	end
end

local m_pauseFlag = 0;

function touchEvent(eventType, x, y)
	ActorManager.checkTap(x, y);

	-- -- ParticleSysManager.createParticle( "slideScreenEffect", ccp(x, y), 5 );
end

function registerProcessObserver(eventName, Observer)
	local value = Observer:getValue();
	local process = tolua.cast(value, "CCFloat"):getValue();
	m_processObserver[Observer] = process;
end

function unregisterProcessObserver(eventName, Observer)
	m_processObserver[Observer] = nil;
end

function registerSkillObserver(skill, Observer)
	m_skillObserver[Observer] = skill;
end

function unregisterSkillObserver(eventName, Observer)
	m_skillObserver[Observer] = nil;
end

function setCreateCount(event, count)
	m_eventCreateCount = count:getValue();
end

function randomCreateCount(event, range)
	math.randomseed(os.time());
	local count = math.random(1, range:getValue());
	m_eventCreateCount = count;
end

function createActorEvent(resource, parent)
	local eventName = m_eventCreateName;
	for i = 1, m_eventCreateCount do
		local height = parent:getHeight();
		local angle = parent:getRotation();
		local newActor = ActorManager.createNewActor("wp", resource, height, 0, angle, i);
		local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
		local actor = tolua.cast(newActor["actor"], "CCNode");
		mainLayer:addChild(actor, actor:getZOrder());
		if (m_eventCreateName) then
			eventName = m_eventCreateName .. "_" .. i;
			if (newActor["is_tap"] == true) then
				newActor["is_tap"] = false;
				newActor["actor"]:createTimer(0.5, ActorManager.setActorCanTap);
			end
			createEvent(eventName, newActor["actor"]);
		end
	end
	m_eventCreateName = nil;
end

function giveMoney(desc, number)
	local money = number:getValue();
	PlayerInfo.modifyMoney(money);
	SceneData.modifyMoney(money);
end

function win(desc)
	m_isWin = true;
end

function activeScene(desc, value)
	local sceneID = value:getValue();
	PlayerInfo.setSceneEnabled(sceneID, true);
end

function setCreateEvent(eventName)
	m_eventCreateName = eventName;
end

function pauseGame()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	AudioEngine.pauseMusic();
	local layer = getSceneLayer(SCENE_MAIN_LAYER);
	layer:onExit();
	PauseInterface.create();
end

function unpauseGame()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	AudioEngine.resumeMusic();
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
	local uiLayer = getSceneLayer(SCENE_UI_LAYER);
	mainLayer:onEnter();
    uiLayer:onEnter();
end

function restartGame()
	local winCB = m_winCB;
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	exitScene();
	AnimLoader:sharedInstance():setPath(PATH_RES_HEROES);
    AnimLoader:sharedInstance():loadAnimData("guanyu");
	enterScene(m_sceneID, m_difficulty, winCB, true);
end


local function calSceneNew()
	local sceneId = SceneData.getSceneID();
	local stage = math.ceil(sceneId/SCENE_COUNT_IN_STAGE);

	local lastSceneId = stage*(SCENE_COUNT_IN_STAGE - 1); -- 10, 20, 30关
	if(PlayerInfo.getSceneEnabled(lastSceneId)) then
		local sceneOffset = (stage - 1) * SCENE_COUNT_IN_STAGE;
		for i = 1,SCENE_COUNT_IN_STAGE do
			local id = sceneOffset + i;
			if(PlayerInfo.getSceneStar(id) >= 3 and PlayerInfo.getSceneStar(id) < 5) then
				if(i > 1) then
					id = id - 1;
				else
					PlayerInfo.setSceneNew(id, true);
					return ;
				end
				if(PlayerInfo.getSceneStar(id) == 5) then
					PlayerInfo.setSceneNew(id + 1, true);
				end
			else
				PlayerInfo.setSceneNew(id, false);
			end
		end
	end
end

--保存场景信息
function saveSceneInfo()
	--结算开启新难度
	calSceneNew();

	local i = 1;
	for i = 1, PlayerInfo.getSceneTotalCount() do
		DocManager.saveBool("scene_enable_" .. i, PlayerInfo.getSceneEnabled(i));
		DocManager.saveInt("scene_star_" .. i, PlayerInfo.getSceneStar(i));
		DocManager.saveBool("scene_isNew_" .. i, PlayerInfo.getSceneNew(i));
	end

	for i = 1, PlayerInfo.getStageTotalCount() do
		DocManager.saveBool("stage_enable_" .. i, PlayerInfo.getStageEnabled(i));
	end

	DocManager.saveInt("money", PlayerInfo.getMoney());
	DocManager.saveInt("token", PlayerInfo.getToken());
	DocManager.saveInt("score", PlayerInfo.getScore());
	DocManager.flush();
end

function registerFunOnLoading()
	Loading.setMapLoader(createBackground);
end


