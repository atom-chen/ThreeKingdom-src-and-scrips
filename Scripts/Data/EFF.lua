module("EFF", package.seeall)

local m_dateBase = {};

m_dateBase["heavy_attack_zhugong_1"] = {
		res = "heavy_attack_zhugong_1", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, box = {w=5,h=150}, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false, hit_eff = "" },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["heavy_attack_zhugong_2"] = {
		res = "heavy_attack_zhugong_2", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false, hit_eff = "" },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["gong"] = {
		res = "gong", pos_x = 1, pos_y = 80,
		stand = { action = "stand", loop = 0, power = 0.5, box = {w=1,h=150}, speed_x = 18, speed_y = -500, next_eff = "die", land_eff = "miss", penetrate = false, hit_eff = "gong_zhong" },
		miss = { action = "miss", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["gong_zhi"] = {
		res = "gong_zhi", pos_x = 0, pos_y = 110,
		stand = { action = "stand", loop = 30, power = 0.5, box = {w=1,h=150}, speed_x = 18, speed_y = 0, next_eff = "die", penetrate = false, hit_eff = "gong_zhong" },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["gong_zhong"] = {
		res = "gong_zhong", pos_x = 0, pos_y = 100,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["huofa"] = {
		res = "huofa", pos_x = 1, pos_y = 250,
		stand = { action = "stand", loop = 0, power = 0.5, box = {w=1,h=150}, speed_x = 18, speed_y = -500, land_eff = "miss", penetrate = false, hit_eff = "huofa_zhong" },
		miss = { action = "miss", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["huofa_zhong"] = {
		res = "huofa_zhong", pos_x = 0, pos_y = 100,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["guai_huofa"] = {
		res = "guai_huofa", pos_x = 2, pos_y = 400,
		stand = { action = "stand", loop = 0, power = 1, box = {w=5,h=150}, speed_x = 20, speed_y = -100, land_eff = "miss", penetrate = false, hit_eff = "guai_huofa_zhong" },
		miss = { action = "miss", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["guai_huofa_zhong"] = {
		res = "guai_huofa_zhong", pos_x = 2, pos_y = 100,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["bingfa"] = {
		res = "bingfa", pos_x = 0, pos_y = 500,
		stand = { action = "stand", loop = 0, power = 1, box = {w=5,h=150}, speed_x = 10, speed_y = -300, land_eff = "miss", penetrate = false, hit_eff = "bingfa_zhong" },
		miss = { action = "miss", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["bingfa_zhong"] = {
		res = "bingfa_zhong", pos_x = 2, pos_y = 100,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["rush"] = {
		res = "rush", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["back"] = {
		res = "back", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["back_1"] = {
		res = "back_1", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["xiakan"] = {
		res = "xiakan", pos_x = 0, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["ciji"] = {
		res = "ciji", pos_x = 0, pos_y = 50,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["jiaxue"] = {
		res = "jiaxue", pos_x = 0, pos_y = 50,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["gongji"] = {
		res = "gongji", pos_x = 0, pos_y = 50,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["fangyu"] = {
		res = "fangyu", pos_x = 0, pos_y = 50,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["liubeidazhao"] = {
		res = "liubeidazhao", pos_x = 0.3, pos_y = 400,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", effect = {time = 0.24, data = "liubeidazhao2"}, penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["liubeidazhao2"] = {
		res = "liubeidazhao2", pos_x = 15, pos_y = -400,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["caocaodazhao"] = {
		res = "caocaodazhao", pos_x = 0.3, pos_y = 400,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", effect = {time = 0.24, data = "caocaodazhao2"}, penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["caocaodazhao2"] = {
		res = "caocaodazhao2", pos_x = 5, pos_y = 1000,
		stand = { action = "stand", loop = 0, power = 0, speed_x = 20, speed_y = -1750, land_eff = "stand2", mov_earth = "beida", penetrate = false },
		stand2 = { action = "stand2", loop = 1, speed_x = 0, speed_y = 0, next_eff = "die" },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["sunquandazhao"] = {
		res = "sunquandazhao", pos_x = 0.3, pos_y = 400,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", effect = {time = 0.24, data = "sunquandazhao2"}, penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["sunquandazhao2"] = {
		res = "sunquandazhao2", pos_x = 0, pos_y = 1000,
		stand = { action = "stand", loop = 0, power = 0, speed_x = 20, speed_y = -1750, land_eff = "stand2", mov_earth = "beida", penetrate = false },
		stand2 = { action = "stand2", loop = 1, speed_x = 0, speed_y = 0, next_eff = "die" },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["beida"] = {
		res = "beida", pos_x = 1, pos_y = 100,
		stand = { action = "stand", loop = 1, power = 0, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["lvbu1_2"] = {
		res = "lvbu1_2", pos_x = 15, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, box = {w=3,h=200}, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["lvbu1_3"] = {
		res = "lvbu1_3", pos_x = 8, pos_y = 0,
		stand = { action = "stand", loop = 1, power = 0, box = {w=3,h=200}, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["zhangjiao1"] = {
		res = "zhangjiao1", pos_x = 0, pos_y = -50,
		stand = { action = "stand", loop = 0, power = 1, box = {w=3,h=150}, speed_x = 20, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

m_dateBase["zhangjiao2"] = {
		res = "zhangjiao2", pos_x = 11, pos_y = -100,
		stand = { action = "stand", loop = 1, power = 1, box = {w=3,h=200}, speed_x = 0, speed_y = 0, next_eff = "die", penetrate = false },
		die = { action = "die", loop = 1, power = 0, speed_x = 0, speed_y = 0 }
}

function getData(type)
	return m_dateBase[type];
end

function getAllData()
	local resList = {};
	for key, effect in pairs(m_dateBase) do
		resList[key] = effect["res"];
	end
	return resList;
end
