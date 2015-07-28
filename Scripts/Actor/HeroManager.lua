module("HeroManager", package.seeall)

require "HeroData"
require "MOV"

local HP_INIT_RATE = 0.4
local FOLLOW_DELAY = 0.03
local HP_STEP = {0.6, 0.31, 0}
local HP_ATTENUATION = {0.02, 0.01, 0}
local HP_SPEED = {2.2, 1.6, 1}

local m_heroes = {};
local m_actorLink = {};

local m_leaderIndex = 2;

local m_isDead = false;

local m_hpTotal = 0;
local m_hpTotalMax = 0;
local m_spTotal = 0;
local m_spTotalMax = 0;
local m_speedRate = 1;
local m_defPhyTotal = 0;
local m_defPsyTotal = 0;

local m_itemShield = 1;

local m_leaderAngle = 0;
local m_footCircle = nil;
local m_circleY = {};

function removeAllHeroes()
	local count = #m_heroes;
	for i = 1, count do
		m_heroes[i]["actor"]:removeFromParentAndCleanup(true);
	end
	m_heroes = {};
	m_actorLink = {};
end

local function setData(actor, type)
	local heroData = {};
	local dataBase = HeroData.getData(type);
	heroData["actor"] = actor;
	heroData["hp"] = dataBase["hp"];
	heroData["hp_max"] = dataBase["hp"];
	heroData["atk_phy"] = dataBase["atk_phy"];
	heroData["atk_psy"] = dataBase["atk_psy"];
	heroData["def_phy"] = dataBase["def_phy"];
	heroData["def_psy"] = dataBase["def_psy"];
	heroData["alert_range"] = dataBase["alert_range"];
	heroData["rect"] = dataBase["rect"];
	heroData["speed_x"] = 0;
	heroData["speed_y"] = 0;
	heroData["a_x"] = 0;
	heroData["a_y"] = 0;
	heroData["attack_num"] = dataBase["attack_num"];
	heroData["mov"] = MOV.getData(dataBase["mov"]);
	heroData["atk"] = ATK.getData(dataBase["atk"]);
	heroData["skill"] = dataBase["skill"];
	heroData["skill_cd"] = dataBase["skill_cd"];
	heroData["interval_count"] = 0;
	heroData["targets"] = {};
	m_heroes[#m_heroes + 1] = heroData;
	if (SHOW_ENEMY_RECT == true and dataBase["rect"]) then
		actor:showRect(dataBase["rect"]["w"]);
	end
	return heroData;
end

function doBehavior(actorLua, behavior)
	if (behavior == nil or behavior == "") then
		return;
	end
	local actor = actorLua["actor"];
	local movSet = actorLua["mov"];
	local mov = movSet[behavior];
	if (mov == nil) then
		return;
	end
	local action = mov["action"];
	local loop = mov["loop"];
	local effect = mov["effect"];
	local atk = actorLua["atk"][behavior];
	local sfx = mov["sfx_res"];
	actorLua["speed_x"] = mov["speed_x"] or 0;
	actorLua["speed_y"] = mov["speed_y"] or 0;
	actorLua["a_x"] = mov["a_x"] or 0;
	actorLua["a_y"] = mov["a_y"] or 0;
	actorLua["behavior"] = behavior;
	actorLua["timer"] = 0;
	actorLua["interval_count"] = 0;
	actorLua["targets"] = {};
	print("**** action = " .. action);
	actor:setAction(action, loop);
	if (effect) then
		local effectTime = effect["time"];
		actorLua["effect"] = EFF.getData(effect["data"]);
		actor:createTimer(effectTime, createEffect);
	end
	if (atk) then
		local buff = atk["buff"];
		if (buff) then
			for i, hero in ipairs(m_heroes) do
				Buff.applyBuff(hero, buff);
			end
		end
		local power = atk["power"];
		if (power < 0) then
			local value = -(power * actorLua["atk_psy"]);
			m_hpTotal = m_hpTotal + value;
			m_hpTotal = math.min(m_hpTotal, m_hpTotalMax);
			actor:showNumber(value, actorLua["rect"]["h"], ccc3(50, 230, 50));
		end
	end
	if (sfx) then
		actor:createTimer(mov["sfx_time"], playSound);
	end
end

function doBehaviorByIndex(index, behavior)
	local actorLua = m_heroes[index];
	doBehavior(actorLua, behavior);
end

function hurt(actorLua, damage, enemyAtk, enemyMov)
	m_hpTotal = m_hpTotal - damage;
	m_hpTotal = math.max(0, m_hpTotal);
	actorLua["actor"]:showNumber("" .. damage, actorLua["rect"]["h"], ccc3(255, 50, 50));
	local heroMov = actorLua["mov"][actorLua["behavior"]];
	if (enemyAtk["hit_eff"]) then
		local effctData = EFF.getData(enemyAtk["hit_eff"]);
		local effectLua = EffectManager.createActor(actorLua, effctData);
		EffectManager.doBehavior(effectLua, "stand");
		local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
		mainLayer:addChild(tolua.cast(effectLua["actor"], "CCNode"), 100);
	end
	if (m_hpTotal <= 0) then
		for i, aActorLua in ipairs(m_heroes) do
			if (heroMov["isVacant"] == true) then
				doBehavior(aActorLua, "sky_die");
			else
				doBehavior(aActorLua, "die");
			end
		end
	else
		if (enemyMov["Hardness"] >= heroMov["Hardness"]) then
			local speed = nil;
			if (heroMov["isVacant"] == true) then
				doBehavior(actorLua, enemyAtk["mov_air"]);
				speed = enemyAtk["speed_air"];
			else
				doBehavior(actorLua, enemyAtk["mov_earth"]);
				speed = enemyAtk["speed_earth"];
			end
			if (speed) then
				actorLua["speed_x"] = actorLua["speed_x"] - speed.x;
				actorLua["speed_y"] = actorLua["speed_y"] - speed.y;
				actorLua["a_x"] = actorLua["a_x"] - speed.a_x;
				actorLua["a_y"] = actorLua["a_y"] - speed.a_y;
			end
		end
	end
	if (actorLua["actor"]:getItemCount() > 0) then
		if (m_itemShield > 0) then
			m_itemShield = m_itemShield - 1;
		else
			actorLua["actor"]:delItem();
		end
	end
end

function useSkill(skillIndex)
	if (m_hpTotal <= 0) then
		return;
	end
	local leader = m_heroes[m_leaderIndex];
	local skillType = skillIndex[leader["behavior"]];
	local skillData = SkillData.getSkillData(skillType);
	if (skillData == nil) then
		return "";
	end

	if (m_hpTotal >= skillData["hp_consume"] and m_spTotal >= skillData["sp_consume"]) then
		m_hpTotal = m_hpTotal - skillData["hp_consume"];
		m_spTotal = m_spTotal - skillData["sp_consume"];
		local time = 0;
		if (skillData["wait_behavior"] and skillData["wait_behavior"] ~= "") then
			for i, hero in ipairs(m_heroes) do
				hero["wait_behavior"] = skillData["wait_behavior"];
				hero["wait_do"] = skillData["behavior"];
			end
		else
			for i, hero in ipairs(m_heroes) do
				if (i == m_leaderIndex) then
					doBehavior(hero, skillData["behavior"]);
				else
					time = time + FOLLOW_DELAY;
					hero["follow_behavior"] = skillData["behavior"];
					hero["actor"]:createTimer(time, followBehavior);
				end
				if (skillData["buff"]) then
					Buff.applyBuff(hero, skillData["buff"]);
				end
			end
		end
	end
	return skillType;
end

function recover(value)
	m_hpTotal = m_hpTotal + value;
	m_hpTotal = math.min(m_hpTotal, m_hpTotalMax);
end

function recoverPercent(value)
	m_hpTotal = m_hpTotal + m_hpTotalMax * value;
	m_hpTotal = math.min(m_hpTotal, m_hpTotalMax);
end

function calcSpTotal(sp)
	m_spTotalMax = sp;
	m_spTotal = 0;
end

function init()
	m_footCircle = {};
	local base = 230;
	local s = 10;
	m_circleY[1] = base;
	m_circleY[2] = m_circleY[1] - s;
	m_circleY[3] = m_circleY[2] - s*2;
	m_circleY[4] = m_circleY[3] - s*2;

    AnimLoader:sharedInstance():setPath(PATH_RES_OTHER);
    AnimLoader:sharedInstance():loadAnimData("yingzi");
end

function createHero(type, res, height, angle, flip)
	local actor = Actor:createActor(res, height, 0);
	actor:setRotation(angle);
	actor:setFlipX(flip);
	actor:registerScriptHandler(updateAnimation);
	local heroData = setData(actor, type);
	m_actorLink[actor] = heroData;

	--创建脚下光圈
	local circle = AnimLoader:createAnimation("yingzi", "Animation1");
	circle = tolua.cast(circle, "CCNode");
	circle:setScale(1.3);
	circle:setPosition(ccp(585, m_circleY[#m_footCircle + 1]));
	m_footCircle[#m_footCircle + 1] = circle;
	getSceneLayer(SCENE_MAIN_LAYER):addChild(circle, 0);
		
    return heroData;
end

function removeHero(index)
	local hero = m_heroes[index]["actor"];
	hero:removeFromParentAndCleanup(true);
	m_actorLink[hero] = nil;
	table.remove(m_heroes, index);
end

function calcHpTotal()
	m_hpTotalMax = 0;
	for i, aActorLua in ipairs(m_heroes) do
		m_hpTotalMax = m_hpTotalMax + aActorLua["hp_max"];
	end
	m_hpTotal = math.floor(m_hpTotalMax * HP_INIT_RATE);
	m_speedRate = 1;
end

function calcDefTotal()
	m_defPhyTotal = 0;
	m_defPsyTotal = 0;
	for i, aActorLua in ipairs(m_heroes) do
		m_defPhyTotal = m_defPhyTotal + aActorLua["def_phy"];
		m_defPsyTotal = m_defPsyTotal + aActorLua["def_psy"];
	end
	for i, aActorLua in ipairs(m_heroes) do
		aActorLua["def_phy"] = m_defPhyTotal;
		aActorLua["def_psy"] = m_defPsyTotal;
	end
end

function getHP()
	return m_hpTotal, m_hpTotalMax;
end

function getSP()
	return m_spTotal, m_spTotalMax;
end

function getHeroes()
	return m_heroes;
end

local function onDie(actorLua)
	m_isDead = true;
end

function Recovery()
	m_isDead = false;
end

local function updateSpeed(actorLua, time)
	if (actorLua["a_x"] ~= 0) then
		actorLua["speed_x"] = actorLua["speed_x"] + actorLua["a_x"] * time;
	end

	if (actorLua["a_y"] ~= 0) then
		actorLua["speed_y"] = actorLua["speed_y"] + actorLua["a_y"] * time;
	end
end

local function getExtraSpeed(actorLua, leader, index)
	if ((index == m_leaderIndex) or (actorLua["behavior"] ~= "walk")) then
		return 0;
	end
	local speed = 0;
	local leaderAngle = leader["actor"]:getRotation();
	local selfAngle = actorLua["actor"]:getRotation();
	if (leaderAngle - selfAngle > (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES) then
		speed = 2;
	elseif (leaderAngle - selfAngle < (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES) then
		speed = -3;
	end
	return speed;
end

local function adjustPosition(actorLua, leader, exSpeed, index)
	if (exSpeed > 0) then
		local leaderAngle = leader["actor"]:getRotation();
		local selfAngle = actorLua["actor"]:getRotation();
		if (leaderAngle - selfAngle < (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES) then
			actorLua["actor"]:setRotation(leaderAngle - (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES);
		end
	elseif (exSpeed < 0) then
		local leaderAngle = leader["actor"]:getRotation();
		local selfAngle = actorLua["actor"]:getRotation();
		if (leaderAngle - selfAngle > (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES) then
			actorLua["actor"]:setRotation(leaderAngle - (index - m_leaderIndex) * DISTANCE_BETWEEN_HEROES);
		end
	end
end

local function checkLanding(actorLua)
	if (actorLua["speed_y"] < 0) then
		if (actorLua["actor"]:getHeight() <= 0) then
			actorLua["actor"]:setHeight(0);
			local behavior = actorLua["mov"][actorLua["behavior"]]["land_mov"] or "stand";
			doBehavior(actorLua, behavior);
		end
	end
end

local function updatePoint(time)
	if (time > 1) then
		return;
	end
	
	for i, rate in ipairs(HP_STEP) do
		if (m_hpTotal / m_hpTotalMax >= rate) then
			m_hpTotal = m_hpTotal - HP_ATTENUATION[i] * time * m_hpTotalMax;
			m_speedRate = HP_SPEED[i];
			break;
		end
	end
	
	if (m_spTotal < m_spTotalMax) then
		m_spTotal = m_spTotal + time;
		m_spTotal = math.min(m_spTotal, m_spTotalMax);
		if (m_spTotal == m_spTotalMax) then
			SceneUI.spFull();
		end
	end
end

local function updateAtkEnable(actorLua)
	if (actorLua["atk"] == nil) then
		return;
	end
	local timer = actorLua["timer"];
	local atk = actorLua["atk"][actorLua["behavior"]];
	local interval = nil;
	if (atk) then
		if ((timer >= atk["atk_begin"]) and (timer <= atk["atk_end"])) then
			actorLua["can_attack"] = true;
		else
			actorLua["can_attack"] = false;
		end
		interval = atk["interval"];
	else
		actorLua["can_attack"] = false;
	end
	if (interval and (timer / interval >= actorLua["interval_count"])) then
		actorLua["interval_count"] = actorLua["interval_count"] + 1;
		actorLua["targets"] = {};
	end
end

function update(time, curAngle, angleMax)

	--改变脚下光圈位置
	for i,v in ipairs(m_footCircle) do
		local angle = m_heroes[i]["actor"]:getRotation();
		local actor = tolua.cast(m_heroes[i].actor, "CCNode");
		-- v:setPosition(ccp(585 + (10 + angle)*ANGLE_TP_X, 230 - (math.abs(angle) - (10 + (i - 1)*DISTANCE_BETWEEN_HEROES ))*3 ));
		v:setPosition(ccp(585 + (10 + angle)*ANGLE_TP_X, 260 ));
	end

	if (m_isDead == true) then
		return 0, m_isDead;
	end

	local leaderSpeed = m_heroes[m_leaderIndex]["speed_x"];
	local isCollision = m_heroes[m_leaderIndex]["isCollision"];

	local speedRate = 1;
	if (m_heroes[m_leaderIndex]["behavior"] == "walk") then
		speedRate = m_speedRate;
	end

	local leaderAngle = leaderSpeed * time * speedRate;
	local rotateAngle = 0;
	m_leaderAngle = m_heroes[m_leaderIndex]["actor"]:getRotation();
	if (leaderSpeed > 0) then
		if (m_leaderAngle >= TEAM_FIRST_POS) then
			rotateAngle = math.min(angleMax - curAngle, leaderAngle);
		end
	elseif (leaderSpeed < 0) then
		if ((curAngle == angleMax)) then
			rotateAngle = math.min(0, m_leaderAngle - TEAM_FIRST_POS - (DISTANCE_BETWEEN_HEROES * (m_leaderIndex - 1)) + leaderAngle);
		else
			rotateAngle = math.max(0, curAngle + leaderAngle) - curAngle;
		end
	end
	curAngle = curAngle + rotateAngle;

	for i, actor in ipairs(m_heroes) do
		local speedX = actor["speed_x"];
		local speedY = actor["speed_y"];
		local exSpeed = getExtraSpeed(actor, m_heroes[m_leaderIndex], i);
		local moveAngle = 0;

		if (actor["isCollision"] == true) then
			actor["isCollision"] = false;
		else
			moveAngle = (speedX + exSpeed) * time * speedRate;
		end
		actor["actor"]:rotateBy(moveAngle - rotateAngle);
		actor["actor"]:moveBy(speedY * time);
		actor["timer"] = actor["timer"] + time;
		checkLanding(actor);
		updateSpeed(actor, time);
		updateAtkEnable(actor);
		adjustPosition(actor, m_heroes[m_leaderIndex], exSpeed, i);
		-- 不能向后退出屏幕
		if (curAngle + actor["actor"]:getRotation() < -20) then
			actor["actor"]:setRotation(-curAngle - 20);
		end
	end

	updatePoint(time);

	if (isCollision) then
		return 0;
	end

	return (rotateAngle / time);
end

function updateAnimation(eventName, actor)
	local actorLua = m_actorLink[actor];

	if ((not m_isDead) and (actorLua["behavior"] == "die")) then
		onDie(actorLua);
		return;
	end
	
	local wait_behavior = actorLua["wait_behavior"];
	if (wait_behavior) then
		actorLua["wait_behavior"] = nil;
		doBehavior(actorLua, actorLua["wait_do"]);
		actorLua["wait_do"] = nil;
		return;
	end

	local nextMov = actorLua["mov"][actorLua["behavior"]]["next_mov"];
	if (nextMov) then
		doBehavior(actorLua, nextMov);
	end
end

function createEffect(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	local effectData = actorLua["effect"];
	local effectLua = EffectManager.createActor(actorLua, effectData);
	local effect = tolua.cast(effectLua["actor"], "CCNode");
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
	mainLayer:addChild(effect, 100);
	EffectManager.doBehavior(effectLua, "stand");
end

function playSound(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	local mov = actorLua["mov"][actorLua["behavior"]];
	local sfx = mov["sfx_res"];
	if (sfx) then
		AudioEngine.playEffect(PATH_RES_AUDIO .. sfx .. ".caf");
	end
end

function followBehavior(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	doBehavior(actorLua, actorLua["follow_behavior"]);
	actorLua["follow_behavior"] = nil;
end

function modifyHP(desc, hp)
	m_hpTotal = m_hpTotal + hp:getValue();
	math.min(math.max(0, m_hpTotal), m_hpTotalMax);
end

function getActorLua(actor)
	return m_actorLink[tolua.cast(actor, "Actor")];
end

function addItemToLeader(resName)
	local leader = m_heroes[m_leaderIndex];
	leader["actor"]:addItem(resName);
	m_itemShield = 1;
end

function delItemFromLeader()
	local leader = m_heroes[m_leaderIndex];
	local function actionEnd()
		leader["actor"]:delAllItem();
	end

	local uiLayer = getSceneLayer(SCENE_UI_LAYER);
	local arr = CCArray:create();
	arr:addObject(CCDelayTime:create(1));
	arr:addObject(CCCallFunc:create( function() actionEnd() end ));	
	uiLayer:runAction(CCSequence:create(arr));
end

function setLeaderTargetForCondition(event, condition)
	local leader = m_heroes[m_leaderIndex]["actor"];
	condition:setTarget(tolua.cast(leader, "CCObject"));
end

function getLeaderName()
	local heroes = PlayerInfo.getQueue();
	return PlayerInfo.getHeroName(heroes[2]);
end

function calcLeaderIndex(haveTank)
	if (haveTank == false) then
		m_leaderIndex = 1;
    else
        m_leaderIndex = 2;
	end
	m_leaderAngle = 0;
	calcSpTotal(m_heroes[m_leaderIndex]["skill_cd"]);
	SceneUI.setSkillIndex(m_heroes[m_leaderIndex]["skill"]);
end

function getLeaderAngle()
	return m_leaderAngle;
end

function doVictoryBehavior()
	local isVacant = false;
	for i, heroLua in ipairs(m_heroes) do
		if (heroLua["actor"]:getHeight() > 0) then
			isVacant = true;
			break;
		end
	end
	if (isVacant == false) then
		for i, heroLua in ipairs(m_heroes) do
			doBehavior(heroLua, "victory");
		end
	end
end