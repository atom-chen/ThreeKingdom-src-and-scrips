module("ATK", package.seeall)

local m_dateBase = {};

m_dateBase["leader"] = {
		normal_attack_1 = { power = 0.3, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_2 = { power = 0.3, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_3 = { power = 0.3, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		jump_slash_attack = { power = 1, atk_begin = 0.1, atk_end = 0.5, box = {w=3.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_fall = { power = 1, atk_begin = 0, atk_end = 0.5, box = {w=3.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		rush = { power = 0.7, atk_begin = 0.1, atk_end = 1, box = {w=3,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		liubeidazhao = { power = 5, atk_begin = 1.2, atk_end = 2, box = {w=30,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		sunquandazhao = { power = 5, atk_begin = 1.5, atk_end = 2, box = {w=30,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		caocaodazhao = { power = 5, atk_begin = 1.5, atk_end = 2, box = {w=30,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["tank1"] = {
		normal_attack_1 = { power = 0.7, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		jump_slash_attack = { power = 1, atk_begin = 0.1, atk_end = 0.5, box = {w=6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_fall = { power = 1.5, atk_begin = 0, atk_end = 0.5, box = {w=8,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		rush = { power = 0.8, atk_begin = 0.1, atk_end = 1, box = {w=6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["tank2"] = {
		normal_attack_1 = { power = 0.4, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		jump_slash_attack = { power = 1, atk_begin = 0.24, atk_end = 0.25, box = {w6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_ready = { power = 1, atk_begin = 0.5, atk_end = 1.5, box = {w6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		rush = { power = 0.8, atk_begin = 0.1, atk_end = 1, box = {w=7,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["tank3"] = {
		normal_attack_1 = { power = 0.3, atk_begin = 0.3, atk_end = 0.65, box = {w=2.5,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		jump_slash_attack = { power = 1, atk_begin = 0.1, atk_end = 0.5, box = {w=6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_fall = { power = 1, atk_begin = 0, atk_end = 0.5, box = {w=8,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		rush = { power = 0.8, atk_begin = 0.1, atk_end = 1, box = {w=6,h=100}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["supporter1"] = {
		normal_attack_1 = { power = -1, atk_begin = 0.1, atk_end = 1, box = {w=2.5,h=100}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_ready = { power = -1, atk_begin = 0.1, atk_end = 1, box = {w=3,h=100}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["supporter2"] = {
		name = { power = power, atk_begin = atk_begin, atk_end = atk_end, box = box, mov_earth = mov_earth, mov_air = mov_air, hit_eff = hit_eff, buff = buff, speed_earth = speed_earth_x, speed_air = speed_earth_y },
		normal_attack_1 = { power = 0, atk_begin = 0.1, atk_end = 1, box = {w=2.5,h=100}, buff = "jiagong", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_ready = { power = 0, atk_begin = 0.1, atk_end = 1, box = {w=3,h=100}, buff = "jiagong", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["supporter3"] = {
		normal_attack_1 = { power = 0, atk_begin = 0.1, atk_end = 1, box = {w=2.5,h=100}, buff = "jiafang", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_ready = { power = 0, atk_begin = 0.1, atk_end = 1, box = {w=3,h=100}, buff = "jiafang", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["supporter4"] = {
		normal_attack_1 = { power = -1, atk_begin = 0.1, atk_end = 1, box = {w=2.5,h=100}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_ready = { power = -1, atk_begin = 0.1, atk_end = 1, box = {w=3,h=100}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["attacke"] = {
		normal_attack_1 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		jump_slash_attack = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		heavy_attack_fall = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, hit_eff = "beida", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["xianjing"] = {
		stand = { power = 1, atk_begin = 0, atk_end = 1, box = {w=0.8,h=1}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["cike"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.5, atk_end = 1.75, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["cike2"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.3, atk_end = 1.9, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["gong1"] = {
		normal_attack_1 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["jin1"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.6, atk_end = 1.75, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["jin2"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.4, atk_end = 2, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["pohuangjinjun"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.7, atk_end = 1.8, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["shimenguai"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.3, atk_end = 1.9, box = {w=5.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["toushiche"] = {
		normal_attack_1 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["fa1"] = {
		normal_attack_1 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=0}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["huangjinjun"] = {
		normal_attack_1 = { power = 1, atk_begin = 1.85, atk_end = 1.93, box = {w=3.5,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["object"] = {

}

m_dateBase["npc"] = {

}

m_dateBase["lvbu1"] = {
		normal_attack_1 = { power = 1, atk_begin = 0.5, atk_end = 0.63, box = {w=15,h=200}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_2 = { power = 1, atk_begin = 1.1, atk_end = 1.7, box = {w=15,h=200}, speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["lvbu2"] = {
		normal_attack_1 = { power = 1, atk_begin = 0.66, atk_end = 1, box = {w=30,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_2 = { power = 1, atk_begin = 1.3, atk_end = 1.8, box = {w=8,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_3 = { power = 0.15, atk_begin = 0.6, atk_end = 4.3, interval = 0.5, box = {w=15,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },

}

m_dateBase["zhangjiao"] = {
		normal_attack_1 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} },
		normal_attack_2 = { power = 0, atk_begin = 0, atk_end = 0, box = {w=0,h=100}, mov_earth = "hurt", speed_earth = {x = 0, y = 0, a_x = 0, a_y = 0}, speed_air = {x = 0, y = 0, a_x = 0, a_y = 0} }
}

m_dateBase["teach"] = {

}

function getData(type)
	return m_dateBase[type];
end

