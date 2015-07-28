module("SkillData", package.seeall)

local m_dateBase = {};
local m_dataIndex = {};

m_dataIndex[1] = {
		stand = "rush", walk = "rush", normal_attack_1 = "rush", normal_attack_2 = "rush", normal_attack_3 = "rush"
}

m_dataIndex[2] = {
		stand = "back", walk = "back", normal_attack_1 = "back", normal_attack_2 = "back", normal_attack_3 = "back"
}

m_dataIndex[3] = {
		stand = "jump", walk = "jump", normal_attack_1 = "jump", normal_attack_2 = "jump", normal_attack_3 = "jump"
}

m_dataIndex[4] = {
		stand = "heavy", walk = "heavy", jump_ready = "jump_slash", jump_rising = "jump_slash", jump_top = "jump_slash",
		normal_attack_1 = "heavy", normal_attack_2 = "heavy", normal_attack_3 = "heavy"
}

m_dataIndex[5] = {
		stand = "dragon", walk = "dragon", normal_attack_1 = "dragon", normal_attack_2 = "dragon", normal_attack_3 = "dragon",
		hurt = "dragon", icon = "dragon", name = "dragon"
}

m_dataIndex[6] = {
		stand = "buff_defense", walk = "buff_defense", normal_attack_1 = "buff_defense", normal_attack_2 = "buff_defense",
		normal_attack_3 = "buff_defense", icon = "shield", name = "shield"
}

m_dataIndex[7] = {
		stand = "frost", walk = "frost", normal_attack_1 = "frost", normal_attack_2 = "frost", normal_attack_3 = "frost",
		hurt = "frost", icon = "frost", name = "frost"
}

m_dateBase["rush"] = {
		behavior = "rush", hp_consume = 0, sp_consume = 0
}

m_dateBase["back"] = {
		behavior = "back", hp_consume = 0, sp_consume = 0
}

m_dateBase["jump"] = {
		behavior = "jump_ready", hp_consume = 0, sp_consume = 0
}

m_dateBase["heavy"] = {
		behavior = "heavy_attack_ready", hp_consume = 0, sp_consume = 0
}

m_dateBase["jump_slash"] = {
		behavior = "jump_slash_top", hp_consume = 0, sp_consume = 0, wait_behavior = "jump_top"
}

m_dateBase["frost"] = {
		behavior = "caocaodazhao", hp_consume = 0, sp_consume = 30
}

m_dateBase["buff_defense"] = {
		behavior = "sunquandazhao", hp_consume = 0, sp_consume = 30
}

m_dateBase["dragon"] = {
		behavior = "liubeidazhao", hp_consume = 0, sp_consume = 30
}

function getSkillIndex(index)
	return m_dataIndex[index];
end

function getSkillIcon(index)
	return m_dataIndex[index]["icon"];
end

function getSkillData(skillType)
	return m_dateBase[skillType];
end