module("PlayerInfo", package.seeall)

local STAGE_COUNT = 3;
local SCENE_COUNT = 33;
local HERO_COUNT = 29;

local LEVEL_MAX = 4;

local HERO_KEY = {
			"guanhai",		-- 1
			"chengong",		-- 2
			"zhangliang",	-- 3
			"xiahoumao",	-- 4
			"xiahouba",		-- 5
			"madai",		-- 6
			"zhoucang",		-- 7
			"xushu",		-- 8
			"qiaoguolao",	-- 9
			"hanxuan",		-- 10
			"xunyu",		-- 11
			"xiahouyuan",	-- 12
			"liubei",		-- 13
			"zhangyan",		-- 14
			"xiahoudun",	-- 15
			"guanxing",		-- 16
			"zhangfeizhizi",-- 17
			"guanfeng",		-- 18
			"simashi",		-- 19
			"daqiao",		-- 20
			"sunquan",		-- 21
			"guanyu",		-- 22
			"zhangbao",		-- 23
			"taishici",		-- 24
			"huangzhong",	-- 25
			"lusu",			-- 26
			"xuchu",		-- 27
			"caocao",		-- 28
			"zhouyu"		-- 29
}

local m_commonInfo = nil;
local m_teamInfo = nil;
local m_sceneInfo = nil;
local m_stageInfo = nil;
local m_starTotal = {0, 0, 0, 0, 0, 0};
local m_indexTable = {};
local m_optionInfo = nil;

function loadCommonInfo()
	m_commonInfo = {};
	m_commonInfo["money"] = DocManager.loadInt("money");
	m_commonInfo["token"] = DocManager.loadInt("token");
	m_commonInfo["score"] = DocManager.loadInt("score");
	m_commonInfo["queue"] = DocManager.loadArrayInt("queue", 4);
end

function loadTeamInfo()
	m_teamInfo = {};
	for i = 1, HERO_COUNT do
		m_teamInfo[i] = {};
		m_teamInfo[i]["isEnabled"] = DocManager.loadBool("hero_enable_" .. i);
		m_teamInfo[i]["level"] = DocManager.loadInt("hero_level_" .. i);
		m_indexTable[HERO_KEY[i]] = i;
	end
end

function loadSceneInfo()
	m_sceneInfo = {};
	for i = 1, SCENE_COUNT do
		m_sceneInfo[i] = {};
		m_sceneInfo[i]["isEnabled"] = DocManager.loadBool("scene_enable_" .. i);
		m_sceneInfo[i]["star"] = DocManager.loadInt("scene_star_" .. i);
		m_sceneInfo[i]["isNew"] = DocManager.loadBool("scene_isNew_" .. i);

		local index = m_sceneInfo[i]["star"] + 1;
		m_starTotal[index] = m_starTotal[index] + 1;
	end
end


function loadStageInfo()
	m_stageInfo = DocManager.loadArrayBool("stage_enable", STAGE_COUNT);
end

function loadOptionInfo()
	m_optionInfo = {};
	m_optionInfo["music_volume"] = DocManager.loadFloat("music_volume");
	m_optionInfo["sound_volume"] = DocManager.loadFloat("sound_volume");
end

function getSceneTotalCount() 
	return SCENE_COUNT;
end

function getHeroName(id)
	return HERO_KEY[id];
end

function getHeroID(name)
	return m_indexTable[name];
end

function getMoney()
	return m_commonInfo.money;
end

function getToken()
	return m_commonInfo.token;
end

function getScore()
	return m_commonInfo.score;
end

function getQueue()
	return m_commonInfo.queue;
end

function getStageTotalCount()
	return STAGE_COUNT;
end

function getStageEnabled(id)
	return m_stageInfo[id];
end

function getSceneEnabled(id)
	return m_sceneInfo[id].isEnabled;
end

function getSceneStar(id)
	return m_sceneInfo[id].star;
end

function getSceneNew(id)
	return m_sceneInfo[id].isNew;
end

function getHeroEnabled(id)
	return m_teamInfo[id].isEnabled;
end

function getHeroLevel(id)
	return m_teamInfo[id].level;
end

function modifyMoney(number)
	m_commonInfo.money = m_commonInfo.money + number;
end

function modifyToken(token)
	m_commonInfo.token = m_commonInfo.token + token;
end

function modifyScore(number)
	m_commonInfo.score = m_commonInfo.score + number;
end

function setQueue(index, id)
	m_commonInfo.queue[index] = id;
end

function setSceneEnabled(id, isEnabled)
	m_sceneInfo[id].isEnabled = isEnabled;
end

function modifySceneStar(id, number)
	if (number <= 0) then
		return;
	end
	local index = m_sceneInfo[id].star + 1;
	m_starTotal[index] = m_starTotal[index] - 1;
	m_sceneInfo[id].star = m_sceneInfo[id].star + number;
	index = m_sceneInfo[id].star + 1;
	m_starTotal[index] = m_starTotal[index] + 1;
end

function setSceneNew(id, isNew)
	m_sceneInfo[id].isNew = isNew;
end

function modifyHeroLevel(id, number)
	m_teamInfo[id].level = math.min(m_teamInfo[id].level + number, LEVEL_MAX);
end

function setHeroEnabled(id, isEnabled)
	m_teamInfo[id].isEnabled = isEnabled;
end

function setStageEnabled(id, isEnabled)
	m_stageInfo[id] = isEnabled;
end

function getHeroTotalCount()
	return HERO_COUNT;
end

function getStarTotalCount(index)
	return m_starTotal[index + 1];
end

function getHeroNextLevel(id)
	local level = m_teamInfo[id].level + 1;
	return math.min(level, LEVEL_MAX);
end

function updateStage()
	for i = 1 , (STAGE_COUNT - 1) do
		local count = 0;
		for j = 1, 10 do
			local id = (i - 1) * 11 + j;
			if (m_sceneInfo[id]["isEnabled"] == true) then
				count = count + 1;
			end
		end
		if (count == 10) then
			m_stageInfo[i + 1] = true;
		end
	end
end

function setMusicVolume(volume)
	m_optionInfo.music_volume = volume;
end

function setSoundVolume(volume)
	m_optionInfo.sound_volume = volume;
end

function getMusicVolume()
	return m_optionInfo.music_volume;
end

function getSoundVolume()
	return m_optionInfo.sound_volume;
end

function saveStageInfo()
	DocManager.saveArrayBool("stage_enable", m_stageInfo);
end

local function checkData()
	local isExist = DocManager.loadBool("not_new_game");
	if (isExist ~= true) then
		local queue = {0, 13, 0, 0}; -- tank | leader | attacker | supported
		local heroEnable = {};
		local heroLevel = {};
		local sceneEnable = {};
		local sceneStar = {};
		local sceneFlag = {};
		local stageEnable = {};

		local money = 0;
		
		for i = 1, HERO_COUNT do
			heroEnable[i] = true;
			heroLevel[i] = 0;
		end
		heroEnable[queue[2]] = true;
		
		for i = 1, SCENE_COUNT do
			sceneEnable[i] = true;
			sceneStar[i] = 0;
			sceneFlag[i] = false;
		end
		sceneEnable[1] = true;

		for i = 1, STAGE_COUNT do
			stageEnable[i] = true;
		end
		stageEnable[1] = true;
		DocManager.saveBool("isAttackProptFinish", false);
		DocManager.saveBool("isUpgradeGuideFinish", false);


		DocManager.saveBool("not_new_game", true);
		DocManager.saveInt("money", money);
		--队列信息，登场的4个人ID
		DocManager.saveArrayInt("queue", queue);
		--各个角色等级
		DocManager.saveArrayInt("hero_level", heroLevel);
		--英雄能否使用
		DocManager.saveArrayBool("hero_enable", heroEnable);
		--场景是否开启
		DocManager.saveArrayBool("scene_enable", sceneEnable);
		--场景的星级
		DocManager.saveArrayInt("scene_star", sceneStar);
		--是否为新开启场景
		DocManager.saveArrayBool("scene_isNew", sceneFlag);
		--大关卡开启
		DocManager.saveArrayBool("stage_enable", stageEnable);
		--音量
		DocManager.saveFloat("music_volume", 1);
		DocManager.saveFloat("sound_volume", 1);
        DocManager.flush();
	end
end

function loadAllInfo()
	checkData();
	loadCommonInfo();
    loadTeamInfo();
    loadSceneInfo();
    loadStageInfo();
    loadOptionInfo();
end

