module("Advance", package.seeall)

require "PlayerInfo"
require "HeroData"

local LEVEL_MAX = 3;

function getHeroListByJob(job)
	local heroList = {};
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		local heroName = PlayerInfo.getHeroName(i);
		local heroData = HeroData.getData(heroName);
		if (heroData.job == job) then
			table.insert(heroList, i);
		end
	end
	return heroList;
end

function checkIsEnabled(id)
	local level = PlayerInfo.getHeroLevel(id);
	return (level < LEVEL_MAX);
end

function getExistHeroesList()
	local heroesState = {};
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		heroesState[i] = PlayerInfo.getHeroEnabled(i);
	end
	return heroesState;
end

function getAdvanceAbleList()
	local enabledList = {};
	local count = PlayerInfo.getHeroTotalCount();
	for i = 1, count do
		enabledList[i] = checkIsEnabled(i);
	end
	return enabledList;
end

function advanceHero(id)
	PlayerInfo.modifyHeroLevel(id, 1);
end

function getHeroDataByLevel(id, level)
	local heroName = PlayerInfo.getHeroName(id);
	if (level > 0) then
		heroName = heroName .. "_" .. level;
	end
	return HeroData.getData(heroName);
end

function getHeroData(id)
	local level = PlayerInfo.getHeroLevel(id);
	local heroData = getHeroDataByLevel(id, level);
	return heroData;
end