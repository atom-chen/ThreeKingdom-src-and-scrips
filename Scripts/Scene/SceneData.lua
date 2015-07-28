module("SceneData", package.seeall)

local m_id = 0;
local m_star = 0;
local m_money = 0;
local m_difficulty = 0;
local m_newHero = 0;
local m_missions = nil;

function resetData()
    m_id = 0;
    m_star = 0;
    m_money = 0;
    m_difficulty = 0;
    m_newHero = 0;
    m_missions = {};
end

function setSceneID(id)
    m_id = id;
end

function setDifficulty(difficulty)
    m_difficulty = difficulty;
end

function addAMission()
    local mission = {};
    mission["time"] = 0;
    mission["timeMax"] = 0;
    mission["count"] = 0;
    mission["complete"] = false;
    table.insert(m_missions, mission);
end

function setMissionTimeMax(time)
    local mission = m_missions[#m_missions];
    mission.timeMax = time;
end

function setMissionCount(count)
    local mission = m_missions[#m_missions];
    mission.count = count;
end

function calcMissionTime(time)
    local mission = m_missions[#m_missions];
    mission.time = mission.timeMax - time;
end

function missionComplete()
    local mission = m_missions[#m_missions];
    mission.complete = true;
end

function modifyStar(number)
    m_star = m_star + number;
end

function modifyMoney(number)
    m_money = m_money + number;
end

function setNewHero(id)
    local isEnabled = PlayerInfo.getHeroEnabled(id);
    if (isEnabled ~= true) then
        m_newHero = id;
    end
end

-- 获取任务数量
function getMissionLength()
    return #m_missions;
end

-- 获取任务完成时间
function getMissionTime(index)
    return m_missions[index].time;
end

-- 获取任务完成数量
function getMissionCount(index)
    return m_missions[index].count;
end

-- 获取任务是否完成
function isMissionComplete(index)
    return m_missions[index].complete;
end

function getSceneID()
    return m_id;
end

function getDifficulty()
    return m_difficulty;
end

-- 获取星级评价
function getStar()
    return m_star;
end

-- 获取金钱收益
function getMoney()
    return m_money;
end

function getNewHero()
    return m_newHero;
end