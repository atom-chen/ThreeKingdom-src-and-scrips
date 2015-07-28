module("ActorManager", package.seeall)

require "ActorData"
require "MOV"

local TAP_DAMAGE = 10;

local m_actors = {};
local m_actorLink = {};

local m_newActors = {};

function removeAllActors()
	local count = #m_actors;
	for i = 1, count do
		m_actors[i]["actor"]:removeFromParentAndCleanup(true);
	end
	m_actors = {};
	m_actorLink = {};
	m_newActors = {};
end

local function setData(actor, type)
	local actorData = {};
	local dataBase = ActorData.getData(type);
	actorData["actor"] = actor;
	actorData["hp"] = dataBase["hp"];
	actorData["hp_max"] = dataBase["hp"];
	actorData["atk_phy"] = dataBase["atk_phy"];
	actorData["atk_psy"] = dataBase["atk_psy"];
	actorData["def_phy"] = dataBase["def_phy"];
	actorData["def_psy"] = dataBase["def_psy"];
	actorData["alert_range"] = dataBase["alert_range"];
	actorData["rect"] = dataBase["rect"];
	actorData["is_enemy"] = dataBase["is_enemy"];
	actorData["is_tap"] = dataBase["is_tap"];
	actorData["attack_num"] = dataBase["attack_num"];
	actorData["emotion"] = dataBase["emotion"];
	actorData["dialog"] = dataBase["dialog"];
	actorData["mov"] = MOV.getData(dataBase["mov"]);
	actorData["atk"] = ATK.getData(dataBase["atk"]);
	actorData["block"] = dataBase["block"];
	actorData["interval_count"] = 0;
	actorData["targets"] = {};

	if (actorData["emotion"]) then
		actor:setEmotion(actorData["emotion"], 0);
	end
	if (actorData["dialog"]) then
		actor:setDialog(actorData["dialog"]);
	end
	if (SHOW_ENEMY_RECT == true and dataBase["is_enemy"] == true and dataBase["rect"]) then
		actor:showRect(dataBase["rect"]["w"]);
	end

	return actorData;
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
	local sfx = mov["sfx_res"];
	actorLua["speed_x"] = mov["speed_x"] or 0;
	actorLua["speed_y"] = mov["speed_y"] or 0;
	actorLua["a_x"] = mov["a_x"] or 0;
	actorLua["a_y"] = mov["a_y"] or 0;
	actorLua["behavior"] = behavior;
	actorLua["timer"] = 0;
	actorLua["interval_count"] = 0;
	actorLua["targets"] = {};

	actor:setAction(action, loop);
	if (effect) then
		local effectTime = effect["time"];
		actorLua["effect"] = EFF.getData(effect["data"]);
		actor:createTimer(effectTime, createEffect);
	end
	if (action == "die") then
		actor:die();
	end
	if (sfx) then
		actor:createTimer(mov["sfx_time"], playSound);
	end
end

function doBehaviorByIndex(index, behavior)
	local actorLua = m_actors[index];
	doBehavior(actorLua, behavior);
end

function hurt(actorLua, damage, heroAtk, heroMov)
	local enemyMov = actorLua["mov"][actorLua["behavior"]];
	if (heroAtk["hit_eff"]) then
		local effctData = EFF.getData(heroAtk["hit_eff"]);
		if(effctData) then
			local effectLua = EffectManager.createActor(actorLua, effctData);
			EffectManager.doBehavior(effectLua, "stand");
			local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
			mainLayer:addChild(tolua.cast(effectLua["actor"], "CCNode"), 100);
		end
	end

	actorLua["hp"] = actorLua["hp"] - damage;
	actorLua["actor"]:showNumber("" .. damage, actorLua["rect"]["h"], ccc3(255, 50, 50));

	if (actorLua["hp"] <= 0) then
		doBehavior(actorLua, "die");
	else
		if (heroMov["Hardness"] >= enemyMov["Hardness"]) then
			local speed = nil;
			if (enemyMov["isVacant"] == true) then
				doBehavior(actorLua, heroAtk["mov_air"]);
				speed = heroAtk["speed_air"];
			else
				doBehavior(actorLua, heroAtk["mov_earth"]);
				speed = heroAtk["speed_earth"];
			end
			if (speed) then
				actorLua["speed_x"] = actorLua["speed_x"] - speed.x;
				actorLua["speed_y"] = actorLua["speed_y"] - speed.y;
				actorLua["a_x"] = actorLua["a_x"] - speed.a_x;
				actorLua["a_y"] = actorLua["a_y"] - speed.a_y;
			end
		end
	end
end

function createActor(type, res, height, speed, angle, flip, index)
	local actor = Actor:createActor(res, height, speed);
	actor:setRotation(angle);
	actor:setFlipX(flip);
	actor:registerScriptHandler(updateAnimation);
	local actorData = setData(actor, type);

	actorData.res = res;

	if (index) then
		table.insert(m_actors, index, actorData);
	else
		table.insert(m_actors, actorData);
	end
	m_actorLink[actor] = actorData;
    return actorData, #m_actors;
end

function createNewActor(type, res, height, speed, angle, index)
	local actor = Actor:createActor(res, height, speed);
	actor:setRotation(angle);
	actor:registerScriptHandler(updateAnimation);
	local actorData = setData(actor, type);

	actorData.res = res;

	if (height >= 0) then
		doBehavior(actorData, "apear_" .. index);
	else
		doBehavior(actorData, "low_apear_" .. index);
	end
	table.insert(m_newActors, actorData);
	m_actorLink[actor] = actorData;
    return actorData;
end

function removeActor(index)
	local actor;
	if (index) then
		actor = m_actors[index]["actor"];
		m_actorLink[actor] = nil;
		actor:removeFromParentAndCleanup(true);
		table.remove(m_actors, index);
	else
		actor = m_actors[#m_actors]["actor"];
		m_actorLink[actor] = nil;
		actor:removeFromParentAndCleanup(true);
		table.remove(m_actors);
	end
end

function getActors()
	return m_actors;
end

function onDie(actorLua)
	actorLua["hp"] = 0;
	actor = tolua.cast(actorLua["actor"], "CCNode");
	m_actorLink[actor] = nil;
	actor:setVisible(false);
	SceneManager.setInvalid(actorLua);
end

local function onTap(actorLua)
	actorLua["actor"]:tapActor();
	actorLua["hp"] = actorLua["hp"] - TAP_DAMAGE;
	if (actorLua["hp"] <= 0) then
		doBehavior(actorLua, "die");
	end
end

function checkTap(x, y)
	for i, actorLua in ipairs(m_actors) do
		if ((actorLua["is_tap"] == true) and (actorLua["hp"] > 0) and (actorLua["mov"][actorLua["behavior"]]["invincible"] ~= true)) then
			local rect = actorLua["actor"]:boundingBox();
			local point = tolua.cast(actorLua["actor"], "CCNode"):convertToNodeSpace(CCPoint(x, y));
			if (rect:containsPoint(point)) then
				onTap(actorLua);
				break;
			end
		end
	end
	for i, actorLua in ipairs(m_newActors) do
		if ((actorLua["is_tap"] == true) and (actorLua["hp"] > 0) and (actorLua["mov"][actorLua["behavior"]]["invincible"] ~= true)) then
			local rect = actorLua["actor"]:boundingBox();
			local point = tolua.cast(actorLua["actor"], "CCNode"):convertToNodeSpace(CCPoint(x, y));
			if (rect:containsPoint(point)) then
				onTap(actorLua);
				break;
			end
		end
	end
end

local function updateSpeed(actorLua, time)
	if (actorLua["a_x"] ~= 0) then
		actorLua["speed_x"] = actorLua["speed_x"] + actorLua["a_x"] * time;
	end

	if (actorLua["a_y"] ~= 0) then
		actorLua["speed_y"] = actorLua["speed_y"] + actorLua["a_y"] * time;
	end
end

local function checkLanding(actorLua)
	if (actorLua["speed_y"] < 0) then
		if (actorLua["actor"]:getHeight() <= 0) then
			actorLua["actor"]:setHeight(0);
			local behavior = actorLua["mov"][actorLua["behavior"]]["land_mov"];
			if (behavior == nil) then
				behavior = "stand";
			end
			doBehavior(actorLua, behavior);
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
	end
	if (interval and (timer / interval >= actorLua["interval_count"])) then
		actorLua["interval_count"] = actorLua["interval_count"] + 1;
		actorLua["targets"] = {};
	end
end

function update(time, angle)
	local removePool = {};
	local removeCount = 0;

	for i, actor in ipairs(m_actors) do
		local speedX = actor["speed_x"];
		local speedY = actor["speed_y"];
		actor["actor"]:rotateBy(-(speedX * time + angle));
		actor["actor"]:moveBy(speedY * time);
		actor["timer"] = actor["timer"] + time;
		checkLanding(actor);
		updateSpeed(actor, time);
		updateAtkEnable(actor);
		if ((actor["actor"]:getRotation() < -SCENE_VISION) or (actor["actor"]:getRotation() > SCENE_VISION)) then
			removeCount = removeCount + 1;
		end
	end

	for i, actor in ipairs(m_newActors) do
		local speedX = actor["speed_x"];
		local speedY = actor["speed_y"];
		actor["actor"]:rotateBy(-(speedX * time + angle));
		actor["actor"]:moveBy(speedY * time);
		actor["timer"] = actor["timer"] + time;
		checkLanding(actor);
		updateSpeed(actor, time);
		updateAtkEnable(actor);
	end
	
	if (angle > 0) then
		for i = 1, removeCount do
			removeActor(1);
		end
		SceneManager.modifyBackIndex(removeCount);
	else
		for i = 1, removeCount do
			removeActor();
		end
		SceneManager.modifyCurIndex(-removeCount);
	end
end

function updateAnimation(eventName, actor)
	actorLua = m_actorLink[actor];

	if (actorLua["behavior"] == "die") then
		onDie(actorLua);
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
	AudioEngine.playEffect(PATH_RES_AUDIO .. sfx .. ".caf");
end

function createAtkBox(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	local endTime = actorLua["atk"][actorLua["behavior"]]["atk_end"];
	actorLua["can_attack"] = true;
	actor:createTimer(endTime, createEffect);
end

function removeAtkBox(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	actorLua["can_attack"] = false;
end

function doActorBehavior(behavior, actor)
	local actorLua = m_actorLink[actor];
	doBehavior(actorLua, behavior);
end

function setEmotion(emotionName, actor)
	if (emotionName) then
		actor:setEmotion(emotionName, 0);
	end
end

function setDialog(dialog, actor)
	if (dialog and dialog ~= "") then
		actor:setDialog(dialog);
	end
end

function setActorCanTap(actor)
	actor = tolua.cast(actor, "Actor");
	local actorLua = m_actorLink[actor];
	actorLua["is_tap"] = true;
end

function setInvalid(actor)
	local actorLua = m_actorLink[tolua.cast(actor, "Actor")];
	if (actorLua) then
		SceneManager.setInvalid(actorLua);
	end
end