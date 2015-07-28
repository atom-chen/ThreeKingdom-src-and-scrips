module("EffectManager", package.seeall)

require "EFF"

local m_effects = {};
local m_effectLink = {};

function getResources()
	AnimLoader:sharedInstance():setPath(PATH_RES_EFFECTS);
	local resList = {};
	local dateBase = EFF.getAllData();
	dateBase["liubeidazhao"] = nil;
	dateBase["liubeidazhao2"] = nil;
	dateBase["caocaodazhao"] = nil;
	dateBase["caocaodazhao2"] = nil;
	dateBase["sunquandazhao"] = nil;
	dateBase["sunquandazhao2"] = nil;
	dateBase["lvbu1_2"] = nil;
	dateBase["lvbu1_3"] = nil;
	dateBase["zhangjiao1"] = nil;
	dateBase["zhangjiao2"] = nil;
	for key, effect in pairs(dateBase) do
		local data = {resType = LOADING_TYPE_ANIM, resName = effect};
		table.insert(resList, data);
	end
	return resList;
end

function removeAllActors()
	local count = #m_effects;
	for i = 1, count do
		m_effects[i]["actor"]:removeFromParentAndCleanup(true);
	end
	m_effects = {};
	m_effectLink = {};
end

local function setData(actor, owner, dataBase)
	local effectData = {};
	effectData["actor"] = actor;
	effectData["atk_phy"] = owner["atk_phy"];
	effectData["atk_psy"] = owner["atk_psy"];
	effectData["eff"] = dataBase;
	effectData["owner"] = owner;
	effectData["targets"] = {};
	effectData["is_enemy"] = owner["is_enemy"];
	effectData["res"] = dataBase["res"];
	m_effects[#m_effects + 1] = effectData;
	return effectData;
end

function doBehavior(actorLua, behavior)
	if (behavior == nil or behavior == "") then
		return;
	end
	local actor = actorLua["actor"];
	local effSet = actorLua["eff"];
	local eff = effSet[behavior];
	local action = eff["action"];
	local loop = eff["loop"];
	local effect = eff["effect"];
	actorLua["box"] = eff["box"];
	actorLua["power"] = eff["power"];
	actorLua["speed_x"] = eff["speed_x"];
	actorLua["speed_y"] = eff["speed_y"];
	actorLua["mov_earth"] = eff["mov_earth"];
	actorLua["mov_air"] = eff["mov_air"];
	actorLua["Hardness"] = eff["Hardness"];
	actorLua["penetrate"] = eff["penetrate"];
	actorLua["auto_lock"] = eff["auto_lock"];
	actorLua["next_eff"] = eff["next_eff"];
	actorLua["hit_eff"] = eff["hit_eff"];
	actorLua["speed_earth"] = eff["speed_earth"];
	actorLua["speed_air"] = eff["speed_air"];
	actorLua["behavior"] = behavior;
	actor:setAction(action, loop);
	if (effect) then
		local effectTime = effect["time"];
		actorLua["effect"] = EFF.getData(effect["data"]);
		actor:createTimer(effectTime, createEffect);
	end
end

function doBehaviorByIndex(index, behavior)
	local actorLua = m_effects[index];
	doBehavior(actorLua, behavior);
end

function createActor(owner, effect)
	local angle = owner["actor"]:getRotation();
	local height = owner["actor"]:getHeight() + (effect["pos_y"] or 0);
	local actor = Actor:createActor(effect["res"], height, 0);
	local isEnemy = owner["is_enemy"];
	if (isEnemy == true) then
		actor:setRotation(angle - (effect["pos_x"] or 0));
	else
		actor:setRotation(angle + (effect["pos_x"] or 0));
	end
	actor:setFlipX(isEnemy == true);
	actor:registerScriptHandler(updateAnimation);
	local effectData = setData(actor, owner, effect);
	m_effectLink[actor] = effectData;
    return effectData;
end

function getEffects()
	return m_effects;
end

local function onDie(actorLua)
	local actor = tolua.cast(actorLua["actor"], "CCNode");
	m_effectLink[actor] = nil;
	actor:removeFromParentAndCleanup(true);
	for i, aActorLua in ipairs(m_effects) do
		if (aActorLua == actorLua) then
			table.remove(m_effects, i);
			break;
		end
	end
end

local function checkLanding(actorLua)
	if (actorLua["speed_y"] < 0) then
		if (actorLua["actor"]:getHeight() <= 0) then
			actorLua["actor"]:setHeight(0);
			local behavior = actorLua["eff"][actorLua["behavior"]]["land_eff"] or "die";
			doBehavior(actorLua, behavior);
		end
	end
end

function update(time, angle)
	for i, actor in ipairs(m_effects) do
		local speedX = actor["speed_x"];
		local speedY = actor["speed_y"];
		local rotate = speedX * time;
		if (actor["owner"]["is_enemy"] == true) then
			rotate = -(rotate + angle);
		else
			rotate = rotate - angle;
		end
		actor["actor"]:rotateBy(rotate);
		actor["actor"]:moveBy(speedY * time);
		checkLanding(actor);
	end
end

function updateAnimation(eventName, actor)
	actorLua = m_effectLink[actor];
	if (actorLua["behavior"] == "die") then
		onDie(actorLua);
		return;
	end
	actorLua["targets"] = {};
	local nextEff = actorLua["next_eff"];
	if (nextEff) then
		doBehavior(actorLua, nextEff);
	end
end

function createEffect(actor)
	local actorLua = m_effectLink[tolua.cast(actor, "Actor")];
	local effectData = actorLua["effect"];
	local effectLua = EffectManager.createActor(actorLua, effectData);
	local effect = tolua.cast(effectLua["actor"], "CCNode");
	local mainLayer = getSceneLayer(SCENE_MAIN_LAYER);
	mainLayer:addChild(effect, 100);
	EffectManager.doBehavior(effectLua, "stand");
end