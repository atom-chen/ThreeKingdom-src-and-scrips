module("AlertCalc", package.seeall)

local function getCollisionData(actorLua0, actorLua1)
	local actor0 = actorLua0["actor"];
	local actor1 = actorLua1["actor"];
	local range = actorLua0["alert_range"];
	local rect = actorLua1["rect"];
	local actor0X = actor0:getRotation();
	local actor1X = actor1:getRotation();
	local result = ((actor0X + range["w"] >= actor1X - rect["w"] / 2) and (actor0X < actor1X + rect["w"] / 2));
	return actor0X, actor1X, range, rect;
end

local function getAttackAction(actorLua)
	local behavior = "normal_attack";
	local count = actorLua["attack_num"];
	math.randomseed(tostring(os.time()):reverse():sub(1, 6));
	behavior = behavior .. "_" .. math.random(count);
	return behavior;
end

local function checkHeroAlert(heroes, enemies)
	for i, heroLua in ipairs(heroes) do
		if ((heroLua["behavior"] == "stand") or (heroLua["behavior"] == "walk")) then
			for j, enemyLua in ipairs(enemies) do
				if ((enemyLua["is_enemy"]) == true and (enemyLua["mov"][enemyLua["behavior"]]["invincible"] ~= true)) then
					local actor0X, actor1X, range, rect = getCollisionData(heroLua, enemyLua);
					if ((actor0X + range["w"] >= actor1X - rect["w"] / 2) and (actor0X < actor1X)) then
						local behavior = getAttackAction(heroLua);
						HeroManager.doBehavior(heroLua, behavior);
						break;
					end
				end
			end
		end
	end
end

local function checkEnemyAlert(enemies, heroes)
	for i, enemyLua in ipairs(enemies) do
		if (enemyLua["is_enemy"] == true) then
			if (enemyLua["alert_range"] and (enemyLua["behavior"] == "stand") or (enemyLua["behavior"] == "walk")) then
				for j, heroLua in ipairs(heroes) do
					if (heroLua["mov"][heroLua["behavior"]]["invincible"] ~= true) then
						local actor0X, actor1X, range, rect = getCollisionData(enemyLua, heroLua);
						if ((actor0X - range["w"] <= actor1X + rect["w"] / 2) and (actor0X > actor1X)) then
							local behavior = getAttackAction(enemyLua);
							ActorManager.doBehavior(enemyLua, behavior);
							break;
						end
					end
				end
			end
		end
	end
end

function checkAlert(team0, team1)
	checkHeroAlert(team0, team1);
	checkEnemyAlert(team1, team0);
end