module("MOV", package.seeall)

local m_dateBase = {};

m_dateBase["attacke1"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "tank3_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.4, data = "huofa"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "atta2_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "atta1_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "tank3_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, effect = {time = 0, data = "huofa"}, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "atta_landing" },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "heavy_attack_sising", Hardness = 1, invincible = false },
		heavy_attack_sising = { action = "heavy_attack_sising", loop = 1, speed_x = 5, speed_y = 2600, a_x = 10, a_y = -15305, isVacant = true, next_mov = "heavy_attack_top", Hardness = 1, invincible = false },
		heavy_attack_top = { action = "heavy_attack_top", loop = 1, speed_x = 8, isVacant = true, next_mov = "heavy_attack_fall", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		heavy_attack_fall = { action = "heavy_attack_fall", loop = 1, speed_x = 5, speed_y = 0, a_y = -35305, isVacant = true, land_mov = "heavy_attack_landing", Hardness = 1, effect = {time = 0, data = "huofa"}, invincible = false, sfx_time = 0, sfx_res = "atta_landing" },
		heavy_attack_landing = { action = "heavy_attack_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		sky_die = { action = "sky_die", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false }
}

m_dateBase["attacke2"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "tank3_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.4, data = "gong_zhi"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "atta2_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "atta1_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "tank3_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, effect = {time = 0.1, data = "gong"}, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "atta_landing" },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "heavy_attack_sising", Hardness = 1, invincible = false },
		heavy_attack_sising = { action = "heavy_attack_sising", loop = 1, speed_x = 5, speed_y = 2600, a_x = 10, a_y = -15305, isVacant = true, next_mov = "heavy_attack_top", Hardness = 1, invincible = false },
		heavy_attack_top = { action = "heavy_attack_top", loop = 1, speed_x = 8, isVacant = true, next_mov = "heavy_attack_fall", Hardness = 1, effect = {time = 0, data = "gong"}, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		heavy_attack_fall = { action = "heavy_attack_fall", loop = 1, speed_x = 5, speed_y = 0, a_y = -35305, isVacant = true, land_mov = "heavy_attack_landing", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta_landing" },
		heavy_attack_landing = { action = "heavy_attack_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		sky_die = { action = "sky_die", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },

}

m_dateBase["leader"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0.3, sfx_res = "back_man" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, effect = {time = 0, data = "rush"}, invincible = false, atk = "rush", sfx_time = 0.3, sfx_res = "rush_man" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.2, data = "ciji"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_2 = { action = "normal_attack_2", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.1, data = "xiakan"}, invincible = false, atk = "normal_attack_2", sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_3 = { action = "normal_attack_3", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false, atk = "normal_attack_3", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "hurt_man" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "din_man" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 1, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "jump_slash_attack" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "slash" },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "heavy_attack_sising", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		heavy_attack_sising = { action = "heavy_attack_sising", loop = 1, speed_x = 5, speed_y = 2600, a_x = 10, a_y = -15305, isVacant = true, next_mov = "heavy_attack_top", Hardness = 1, invincible = false },
		heavy_attack_top = { action = "heavy_attack_top", loop = 1, speed_x = 8, isVacant = true, next_mov = "heavy_attack_fall", Hardness = 1, invincible = false },
		heavy_attack_fall = { action = "heavy_attack_fall", loop = 1, speed_x = 5, speed_y = 0, a_y = -35305, isVacant = true, land_mov = "heavy_attack_landing", Hardness = 1, invincible = false, atk = "heavy_attack_fall", sfx_time = 0, sfx_res = "slash" },
		heavy_attack_landing = { action = "heavy_attack_landing", loop = 1, isVacant = true, next_mov = "walk", Hardness = 1, effect = {time = 0, data = "heavy_attack_zhugong_2"}, invincible = false },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false, sfx_time = 0, sfx_res = "victory" },
		drop = { action = "drop", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },
		liubeidazhao = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, effect = {time = 0.8, data = "liubeidazhao"}, invincible = false, atk = "liubeidazhao" },
		sunquandazhao = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, effect = {time = 0.8, data = "sunquandazhao"}, invincible = false, atk = "sunquandazhao" },
		caocaodazhao = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, effect = {time = 0.8, data = "caocaodazhao"}, invincible = false, atk = "caocaodazhao" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },

}

m_dateBase["tank1"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0.3, sfx_res = "back_man" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, effect = {time = 0, data = "rush"}, invincible = false, atk = "rush", sfx_time = 0.3, sfx_res = "rush_man" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.2, data = "ciji"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "hurt_man" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "din_man" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 1, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "jump_slash_attack" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "slash" },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "heavy_attack_sising", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		heavy_attack_sising = { action = "heavy_attack_sising", loop = 1, speed_x = 5, speed_y = 2600, a_x = 10, a_y = -15305, isVacant = true, next_mov = "heavy_attack_top", Hardness = 1, invincible = false },
		heavy_attack_top = { action = "heavy_attack_top", loop = 1, speed_x = 8, isVacant = true, next_mov = "heavy_attack_fall", Hardness = 1, invincible = false },
		heavy_attack_fall = { action = "heavy_attack_fall", loop = 1, speed_x = 5, speed_y = 0, a_y = -35305, isVacant = true, land_mov = "heavy_attack_landing", Hardness = 1, invincible = false, atk = "heavy_attack_fall", sfx_time = 0, sfx_res = "slash" },
		heavy_attack_landing = { action = "heavy_attack_landing", loop = 1, isVacant = true, next_mov = "walk", Hardness = 1, invincible = false },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false, sfx_time = 0, sfx_res = "victory" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },

}

m_dateBase["tank2"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0.3, sfx_res = "back_man" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, effect = {time = 0, data = "rush"}, invincible = false, atk = "rush", sfx_time = 0.3, sfx_res = "rush_man" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.2, data = "ciji"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "hurt_man" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "din_man" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "landing" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack" },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "jump_slash_attack" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0, data = "back_1"}, invincible = false, sfx_time = 0, sfx_res = "slash" },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "heavy_attack_go", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "back_man" },
		heavy_attack_go = { action = "heavy_attack_go", loop = 1, speed_x = 5, a_x = 10, isVacant = false, next_mov = "heavy_attack_end", Hardness = 1, invincible = false, atk = "heavy_attack_fall" },
		heavy_attack_end = { action = "heavy_attack_end", loop = 1, speed_x = 5, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "slash" },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false, sfx_time = 0, sfx_res = "victory" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true }
}

m_dateBase["tank3"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "tank1_back" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, atk = "rush", sfx_time = 0, sfx_res = "tank3_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false, atk = "normal_attack_1", sfx_time = 0, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "tank3_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "tank3_die" },
		jump_ready = { action = "jump_ready", loop = 1, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 8, speed_y = 1000, a_x = 0, a_y = -1750, isVacant = true, next_mov = "jump_top", Hardness = 0, invincible = false },
		jump_top = { action = "jump_top", loop = 1, speed_x = 5, speed_y = 125, a_x = 0, a_y = -1000, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 3, speed_y = -125, a_x = 0, a_y = -10000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 0.5, speed_y = -125, a_x = 0, a_y = -10000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, atk = "jump_slash_attack", sfx_time = 0, sfx_res = "tank3_fall" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "heavy_attack_sising", Hardness = 1, invincible = false },
		heavy_attack_sising = { action = "heavy_attack_sising", loop = 1, speed_x = 3, speed_y = 3200, a_x = 0, a_y = -9600, isVacant = true, next_mov = "heavy_attack_top", Hardness = 1, invincible = false },
		heavy_attack_top = { action = "heavy_attack_top", loop = 1, speed_x = 2, a_x = 0, isVacant = true, next_mov = "heavy_attack_fall", Hardness = 1, invincible = false },
		heavy_attack_fall = { action = "heavy_attack_fall", loop = 1, speed_x = 1, speed_y = -8000, a_x = 0, a_y = -8000, isVacant = true, land_mov = "heavy_attack_landing", Hardness = 1, invincible = false, atk = "heavy_attack_fall", sfx_time = 0, sfx_res = "tank3_fall" },
		heavy_attack_landing = { action = "heavy_attack_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },

}

m_dateBase["supporter1"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "supp1_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "jiaxue"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "supp1_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "supp1_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "suup1_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "suup1_fall" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 7, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "jiaxue"}, invincible = false, sfx_time = 0.7, sfx_res = "supporter" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },

}

m_dateBase["supporter2"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta2_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "gongji"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "supp2_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "supp2_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "supp2_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "gongji"}, invincible = false, sfx_time = 0.7, sfx_res = "supporter" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },

}

m_dateBase["supporter3"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta2_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "fangyu"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "supp2_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "supp2_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "supp2_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "fangyu"}, invincible = false, sfx_time = 0.7, sfx_res = "supporter" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false },

}

m_dateBase["supporter4"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = true },
		walk = { action = "go", loop = 0, speed_x = 3.5, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false },
		back = { action = "back", loop = 1, speed_x = -25, a_x = 15, isVacant = false, next_mov = "back_1", Hardness = 0, effect = {time = 0, data = "back"}, invincible = false, sfx_time = 0, sfx_res = "atta1_rush" },
		back_1 = { action = "back_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, effect = {time = 0, data = "back_1"} },
		rush = { action = "rush", loop = 1, speed_x = 15, a_x = -5, isVacant = false, next_mov = "rush_1", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "supp1_rush" },
		rush_1 = { action = "rush_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0 },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "jiaxue"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		hurt = { action = "hurt", loop = 1, isVacant = false, next_mov = "walk", Hardness = 5, invincible = false, sfx_time = 0, sfx_res = "supp1_hurt" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "", Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "supp1_die" },
		jump_ready = { action = "jump_ready", loop = 1, speed_x = 2, isVacant = false, next_mov = "jump_rising", Hardness = 0, invincible = false },
		jump_rising = { action = "jump_rising", loop = 1, speed_x = 10, speed_y = 3900, a_x = 15, a_y = -11478, isVacant = true, next_mov = "jump_fall", Hardness = 0, invincible = false },
		jump_fall = { action = "jump_fall", loop = 1, speed_x = 10, speed_y = 0, a_y = -30000, isVacant = true, land_mov = "jump_landing", Hardness = 0, invincible = false },
		jump_landing = { action = "jump_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 0, invincible = false, sfx_time = 0, sfx_res = "suup1_fall" },
		jump_slash_top = { action = "jump_slash_top", loop = 1, isVacant = true, next_mov = "jump_slash_attack", Hardness = 0, invincible = false },
		jump_slash_attack = { action = "jump_slash_attack", loop = 1, speed_x = 10, speed_y = 0, a_y = -40000, isVacant = true, land_mov = "jump_slash_landing", Hardness = 1, invincible = false, sfx_time = 0, sfx_res = "suup1_fall" },
		jump_slash_landing = { action = "jump_slash_landing", loop = 1, isVacant = false, next_mov = "walk", Hardness = 1, invincible = false },
		heavy_attack_ready = { action = "heavy_attack_ready", loop = 1, speed_x = 3, isVacant = false, next_mov = "walk", Hardness = 1, effect = {time = 0.7, data = "jiaxue"}, invincible = false, sfx_time = 0.7, sfx_res = "supporter" },
		sky_die = { action = "stand", loop = 0, speed_y = -250, a_y = -5000, isVacant = true, land_mov = "die", Hardness = 100, invincible = true },
		victory = { action = "victory", loop = 1, isVacant = false, next_mov = "walk", Hardness = 99, invincible = false }
}

m_dateBase["fa1"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, effect = {time = 1.75, data = "bingfa"}, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "die" }
}

m_dateBase["cike"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "cike_die" }
}

m_dateBase["cike2"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "cike_die" }
}

m_dateBase["gong1"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, effect = {time = 2.36, data = "gong_zhi"}, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "die" }
}

m_dateBase["huangjinjun"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "cike_die" }
}

m_dateBase["jin1"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "die" }
}

m_dateBase["jin2"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "die" }
}

m_dateBase["pohuangjinjun"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "cike_die" }
}

m_dateBase["toushiche"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, effect = {time = 1.1, data = "guai_huofa"}, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "si_die" }
}

m_dateBase["xianjing"] = {
		stand = { action = "stand", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = -1, invincible = true, atk = "stand" },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = -1, invincible = true }
}

m_dateBase["object"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = true },

}

m_dateBase["npc"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false }
}

m_dateBase["shimenguai"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1" },
		hurt = { action = "hurt", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = false },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true, sfx_time = 0, sfx_res = "si_die" }
}

m_dateBase["wp"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		open = { action = "open", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true },
		open1 = { action = "open1", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = true },
		act1 = { action = "act1", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true },
		act2 = { action = "act2", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 5, invincible = true },
		die = { action = "die", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false },
		apear_1 = { action = "stand", loop = 1, speed_x = -10, speed_y = 800, a_x = 0, a_y = -1000, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		apear_2 = { action = "stand", loop = 1, speed_x = -12, speed_y = 700, a_x = 0, a_y = -1200, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		apear_3 = { action = "stand", loop = 1, speed_x = -14, speed_y = 600, a_x = 0, a_y = -1400, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		low_apear_1 = { action = "stand", loop = 1, speed_x = -9, speed_y = 1000, a_x = 0, a_y = -1000, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		low_apear_2 = { action = "stand", loop = 1, speed_x = -10, speed_y = 900, a_x = 0, a_y = -1200, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		low_apear_3 = { action = "stand", loop = 1, speed_x = -11, speed_y = 800, a_x = 0, a_y = -1400, isVacant = true, next_mov = "stand", Hardness = 0, invincible = true },
		juanzhouopen = { action = "open", loop = 1, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = false }
}

m_dateBase["lvbu1"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_2 = { action = "normal_attack_2", loop = 1, isVacant = false, next_mov = "stand", Hardness = 3, effect = {time = 1.1, data = "lvbu1_2"}, invincible = false, atk = "normal_attack_2" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "stand", Hardness = 99, invincible = true, sfx_time = 0, sfx_res = "lvbu_die" }
}

m_dateBase["lvbu2"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "stand", Hardness = 1, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_2 = { action = "normal_attack_2", loop = 1, isVacant = false, next_mov = "stand", Hardness = 2, effect = {time = 1.3, data = "lvbu1_3"}, invincible = false, atk = "normal_attack_2" },
		normal_attack_3 = { action = "normal_attack_3", loop = 1, isVacant = false, next_mov = "stand", Hardness = 3, invincible = false, atk = "normal_attack_3" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "stand", Hardness = 99, invincible = true, sfx_time = 0, sfx_res = "lvbu_die" }
}

m_dateBase["zhangjiao"] = {
		stand = { action = "stand", loop = 0, isVacant = false, Hardness = 0, invincible = false },
		normal_attack_1 = { action = "normal_attack_1", loop = 1, isVacant = false, next_mov = "stand", Hardness = 1, effect = {time = 1, data = "zhangjiao1"}, invincible = false, atk = "normal_attack_1", sfx_time = 0.3, sfx_res = "slash" },
		normal_attack_2 = { action = "normal_attack_2", loop = 1, isVacant = false, next_mov = "stand", Hardness = 2, effect = {time = 3.5, data = "zhangjiao2"}, invincible = false, atk = "normal_attack_2" },
		die = { action = "die", loop = 1, isVacant = false, next_mov = "stand", Hardness = 99, invincible = true, sfx_time = 0, sfx_res = "zhangjiao_die" }
}

m_dateBase["teach"] = {
		stand = { action = "stand", loop = 0, speed_x = 0, speed_y = 0, a_x = 0, a_y = 0, isVacant = false, Hardness = 0, invincible = true },

}

function getData(type)
	return m_dateBase[type];
end

