module("Collision", package.seeall)

local function isCollision(x0, y0, w0, h0, x1, y1, w1, h1)
	local res = ( (x0 + w0 < x1 - w1 / 2) or (x1 + w1 < x0 - w0 / 2) or (y0 + h0 < y1) or (y1 + h1 < y0) );
	return (not res);
end

local function getCollisionData(actorLua, isAttack)
	local actor = actorLua["actor"];
	local x = actor:getRotation();
	local y = actor:getHeight();
	local mov = actorLua["mov"][actorLua["behavior"]];
	local atk = actorLua["atk"][mov["atk"]];
	local box = nil;
	if (isAttack) then
		if (atk and actorLua["can_attack"] == true) then
			box = atk["box"];
		end
	else
		box = actorLua["rect"];
	end
	return x, y, mov, atk, box;
end

local function getEffectCollisionData(effectLua)
	local actor = effectLua["actor"];
	local x = actor:getRotation();
	local y = actor:getHeight();
	local box = effectLua["box"];
	return x, y, box;
end

local function calcDamage(atk, def, power)
	power = power or 0;
	local dmgPhy = atk["atk_phy"] - def["def_phy"];
	local dmgPsy = atk["atk_psy"] - def["def_psy"];
	local damage = math.max(dmgPhy, dmgPsy);
	damage = (damage *math.random(90, 110))/100; -- 伤害公式随机 %90 - %110
	damage = math.max(1, math.floor(damage * power));
	damage = math.ceil(damage);
	return damage;
end

local function calcEffectDamage(effectLua, actorLua)
	local dmgPhy = effectLua["atk_phy"] - actorLua["def_phy"];
	local dmgPsy = effectLua["atk_psy"] - actorLua["def_psy"];
	local damage = math.max(dmgPhy, dmgPsy);
	damage = math.floor(damage * effectLua["power"]);
	damage = (damage *math.random(90, 110))/100; -- 伤害公式随机 %90 - %110
	damage = math.ceil( math.max(damage, 1));
	return damage;
end

local function checkHeroCollision(heroes, enemies)
	for i, heroLua in ipairs(heroes) do
		local heroX, heroY, heroMov, heroAtk, heroBox = getCollisionData(heroLua, true);
		if (heroBox) then
			for j, enemyLua in ipairs(enemies) do
				if ((enemyLua["is_enemy"] == true) and (not heroLua["targets"][enemyLua]) and (enemyLua["hp"] > 0)) then
					local enemyX, enemyY, enemyMov, enemyAtk, enemyBox = getCollisionData(enemyLua, false);
					local invincible = enemyMov["invincible"];
					if ((not invincible)) then
						local result = isCollision(heroX, heroY, heroBox["w"], heroBox["h"], enemyX, enemyY, enemyBox["w"], enemyBox["h"]);
						if (result == true) then
							local damage = calcDamage(heroLua, enemyLua, heroAtk["power"]);
							heroLua["targets"][enemyLua] = true;
							ActorManager.hurt(enemyLua, damage, heroAtk, heroLua["mov"][heroLua["behavior"]]);
						end
					end
				end
			end
		end
	end
end

local function checkEnemyCollision(enemies, heroes)
	for i, enemyLua in ipairs(enemies) do
		if (enemyLua["hp"] > 0) then
			local enemyX, enemyY, enemyMov, enemyAtk, enemyBox = getCollisionData(enemyLua, true);
			if (enemyBox) then
				for j, heroLua in ipairs(heroes) do
					if (not enemyLua["targets"][heroLua]) then
						local heroX, heroY, heroMov, heroAtk, heroBox = getCollisionData(heroLua, false);
						local invincible = heroMov["invincible"];
						if ((not invincible)) then
							local result = isCollision(enemyX, enemyY, enemyBox["w"], enemyBox["h"], heroX, heroY, heroBox["w"], heroBox["h"]);
							if (result == true) then
								local damage = calcDamage(enemyLua, heroLua, enemyAtk["power"]);
								enemyLua["targets"][heroLua] = true;
								HeroManager.hurt(heroLua, damage, enemyAtk, enemyLua["mov"][enemyLua["behavior"]]);
							end
						end
					end
				end
			end
		end
	end
end

local function checkSingleEffectCollision(effectX, effectY, effectBox, actorLua)
	local actorX, actorY, actorMov, actorAtk, actorBox = getCollisionData(actorLua, false);
	local invincible = actorMov["invincible"];
	if (invincible == true) then
		return false;
	end
	local result = isCollision(effectX, effectY, effectBox["w"], effectBox["h"], actorX, actorY, actorBox["w"], actorBox["h"]);
	return result, actorMov;
end

local function checkEffectCollision(effects, heroes, enemies)
	for i, effectLua in ipairs(effects) do
		local effectX, effectY, effectBox = getEffectCollisionData(effectLua);
		if (effectBox) then
			if (effectLua["owner"]["is_enemy"] == true) then
				for j, heroLua in ipairs(heroes) do
					if (not effectLua["targets"][heroLua]) then
						local isHit, heroMov = checkSingleEffectCollision(effectX, effectY, effectBox, heroLua);
						if (isHit == true) then
							local damage = calcEffectDamage(effectLua, heroLua);
							effectLua["targets"][heroLua] = true;
							HeroManager.hurt(heroLua, damage, effectLua, heroMov);
							if (effectLua["penetrate"] ~= true) then
								tolua.cast(effectLua["actor"], "CCNode"):setVisible(false);
								EffectManager.doBehavior(effectLua, "die");
								break;
							end
						end
					end
				end
			else
				for j, enemyLua in ipairs(enemies) do
					if ((enemyLua["is_enemy"] == true) and (not effectLua["targets"][enemyLua])) then
						local isHit, enemyMov = checkSingleEffectCollision(effectX, effectY, effectBox, enemyLua);
						if (isHit == true) then
							local damage = calcEffectDamage(effectLua, enemyLua);
							effectLua["targets"][enemyLua] = true;
							ActorManager.hurt(enemyLua, damage, effectLua, enemyMov);
							if (effectLua["penetrate"] ~= true) then
								tolua.cast(effectLua["actor"], "CCNode"):setVisible(false);
								EffectManager.doBehavior(effectLua, "die");
								break;
							end
						end
					end
				end
			end
		end
	end
end

local function checkRectCollision(heroes, enemies)
	local boxH = 0;
	for i, heroLua in ipairs(heroes) do
		local heroX, heroY, heroMov, heroAtk, heroBox = getCollisionData(heroLua, false);
		if (heroBox) then
			for j, enemyLua in ipairs(enemies) do
				if (enemyLua["is_enemy"] == true and enemyLua["hp"] > 0) then
					local enemyX, enemyY, enemyMov, enemyAtk, enemyBox = getCollisionData(enemyLua, false);
					if (enemyLua["block"] == true) then
						boxH = SCREEN_HEIGHT;
					else
						boxH = enemyBox["h"];
					end
					local result = isCollision(heroX, heroY, heroBox["w"], heroBox["h"], enemyX, enemyY, enemyBox["w"], boxH);
					if ((result == true) and (heroLua["speed_x"] > 0)) then
						heroLua["isCollision"] = true;
					end
				end
			end
		end
	end
end

function checkCollision(team0, team1, team2)
	checkHeroCollision(team0, team1);
	checkEnemyCollision(team1, team0);
	checkEffectCollision(team2, team0, team1);
	checkRectCollision(team0, team1);
end