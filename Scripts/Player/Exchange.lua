module("Exchange", package.seeall)

require "PlayerInfo"

local m_dateBase = {};

m_dateBase["guanhai"] = {};
m_dateBase["chengong"] = {};
m_dateBase["zhangliang"] = { hero = {"guanhai", "zhangbao", "zhangyan"}, star = {} };
m_dateBase["xiahoumao"] = {};
m_dateBase["xiahouba"] = {};
m_dateBase["madai"] = {};
m_dateBase["zhoucang"] = {};
m_dateBase["xushu"] = {};
m_dateBase["qiaoguolao"] = {};
m_dateBase["hanxuan"] = {};
m_dateBase["xunyu"] = {};
m_dateBase["xiahouyuan"] = { hero = {}, star = {4, 10} };
m_dateBase["liubei"] = {};
m_dateBase["zhangyan"] = {};
m_dateBase["xiahoudun"] = { hero = {"xiahoumao", "xiahouba", "xiahouyuan"}, star = {} };
m_dateBase["guanxing"] = { hero = {"zhoucang", "xiahouyuan", "madai"}, star = {} };
m_dateBase["zhangfeizhizi"] = {};
m_dateBase["guanfeng"] = {};
m_dateBase["simashi"] = {};
m_dateBase["daqiao"] = { hero = {}, star = {4, 20} };
m_dateBase["sunquan"] = { hero = {}, star = {5, 15} };
m_dateBase["guanyu"] = { hero = {}, star = {5, 30} };
m_dateBase["zhangbao"] = {};
m_dateBase["taishici"] = {};
m_dateBase["huangzhong"] = { hero = {}, star = {4, 30} };
m_dateBase["lusu"] = { hero = {}, star = {5, 10} };
m_dateBase["xuchu"] = {};
m_dateBase["caocao"] = { hero = {}, star = {5, 25} };
m_dateBase["zhouyu"] = { hero = {}, star = {5, 20} };

local HERO_STATE_NONE = 0;
local HERO_STATE_ENABLE = 1;
local HERO_STATE_EXIST = 2;

function checkIsEnabled(id)
	local heroName = PlayerInfo.getHeroName(id);
	local hero = m_dateBase[heroName].hero;
	local star = m_dateBase[heroName].star;
	local res = true;

	if ((not hero) and (not star)) then
		return false;
	end

	for i, name in ipairs(hero) do
		local index = PlayerInfo.getHeroID(name);
		res = PlayerInfo.getHeroEnabled(index);
		if (res == false) then
			break;
		end
	end

	if (#star > 0) then
		if(star[1] == 4) then
			if(PlayerInfo.getStarTotalCount(4) < star[2] and PlayerInfo.getStarTotalCount(5) < star[2]) then
				return false;
			end
		end

		if(star[1] == 5) then
			if(PlayerInfo.getStarTotalCount(5) < star[2]) then
				return false;
			end
		end
	end
	return res;
end

function getExistHeroesList()
	local heroesState = {};
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		heroesState[i] = PlayerInfo.getHeroEnabled(i);
	end
	return heroesState;
end

function getExchangeAbleList()
	local enabledList = {};
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		enabledList[i] = checkIsEnabled(i);
	end
	return enabledList;
end

function getHeroesStateList()
	local resList = {};
	local heroesState = getExistHeroesList();
	local enabledList = getExchangeAbleList();
	local count = #heroesState;
	for i = 1, count do
		if (heroesState[i] == true) then
			resList[i] = HERO_STATE_EXIST;
		elseif (enabledList[i] == true) then
			resList[i] = HERO_STATE_ENABLE;
		else
			resList[i] = HERO_STATE_EXIST;
		end
	end
end

function exchangeBonus(id)
	PlayerInfo.setHeroEnabled(id, true);
end















