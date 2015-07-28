module("MapData", package.seeall)

local m_dateBase = {};
local m_mapIndex = {1, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4,
					2, 2, 3, 3, 4, 3, 3, 1, 1, 1, 2,
					4, 3, 4, 3, 2, 2, 3, 1, 3, 4, 1};

m_dateBase[1] = {
		{ tile = "tile_road", height = 38, distance = 17.3, angle = 0, z = 0, speed = 1, scale = 1 },
		{ tile = "tile_hill_house", height = 700, distance = 50, angle = 0, z = -10, speed = 0.8, scale = 2 },
		-- { tile = "tile_hill2_house", height = 800, distance = 50, angle = -25, z = -10, speed = 0.8, scale = 2 },
		{ tile = "tile_hill3", height = 700, distance = 33, angle = 10, z = -20, speed = 0.6, scale = 2 },
		{ tile = "tile_far_hill", height = 720, distance = 25, angle = 0, z = -30, speed = 0.5, scale = 2 },
		-- { tile = "tile_cloud", height = 850, distance = 20, angle = 0, z = -20, speed = 0.5, scale = 2 },
		{ tile = "tile_farest", height = 1000, distance = 13, angle = 0, z = -50, speed = 0.25, scale = 2 }
}--村庄

m_dateBase[2] = {
		{ tile = "tile_road2", height = 38, distance = 17.3, angle = 0, z = 0, speed = 1, scale = 1 },
		-- { tile = "tile_villa", height = 900, distance = 70, angle = 0, z = -10, speed = 0.8, scale = 2 },--已删除
		-- { tile = "tile_house", height = 600, distance = 50, angle = -25, z = -10, speed = 0.8, scale = 2 },
		{ tile = "tile_tower", height = 1000, distance = 40, angle = 10, z = -20, speed = 0.6, scale = 2 },
		-- { tile = "tile_double_tower", height = 1000, distance = 25, angle = 5, z = -30, speed = 0.6, scale = 2 },
		{ tile = "tile_tower2", height = 1100, distance = 40, angle = 20, z = -20, speed = 0.5, scale = 2 },
		-- { tile = "tile_cloud", height = 850, distance = 30, angle = 0, z = -20, speed = 0.5, scale = 2 },
		{ tile = "tile_farest", height = 800, distance = 13, angle = 0, z = -50, speed = 0.25, scale = 2 }
}--城市

m_dateBase[3] = {
		{ tile = "tile_road4", height = 38, distance = 17.3, angle = 0, z = 0, speed = 1, scale = 1 },
		{ tile = "tile_forest_tree2", height = 480, distance = 10, angle = 0, z = -10, speed = 0.8, scale = 2 },
		{ tile = "tile_forest_tree3", height = 810, distance = 30, angle = 10, z = -20, speed = 0.6, scale = 2 },
		-- { tile = "tile_cloud", height = 1050, distance = 30, angle = 0, z = -20, speed = 0.5, scale = 2 },
		{ tile = "tile_farest", height = 950, distance = 13, angle = 0, z = -50, speed = 0.25, scale = 2 }
}--树林

m_dateBase[4] = {
		{ tile = "tile_road4", height = 38, distance = 17.3, angle = 0, z = 0, speed = 1, scale = 1 },
		-- { tile = "tile_peach_tree", height = 750, distance = 15, angle = 0, z = -10, speed = 0.8, scale = 2 },
		{ tile = "tile_peach_tree2", height = 750, distance = 15, angle = -20, z = -10, speed = 0.8, scale = 2 },
		{ tile = "tile_peach_flower", height = 750, distance = 25, angle = 10, z = -20, speed = 0.6, scale = 2 },
		-- { tile = "tile_cloud", height = 1050, distance = 30, angle = 0, z = -20, speed = 0.5, scale = 2 },
		{ tile = "tile_farest", height = 1000, distance = 13, angle = 0, z = -50, speed = 0.25, scale = 2 }
}--桃花

function getData(index)
	return m_dateBase[m_mapIndex[index]];
end