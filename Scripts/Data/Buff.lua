module("Buff", package.seeall)

local m_dateBase = {};

m_dateBase["jiagong"] = {
		time = 5, atk_phy = 0.3, atk_psy = 0.3, def_phy = 0, def_psy = 0
}

m_dateBase["jiafang"] = {
		time = 5, atk_phy = 0, atk_psy = 0, def_phy = 0.3, def_psy = 0.3
}

function getData(type)
	return m_dateBase[type];
end

function applyBuff(owner, type)
	if (owner.buff ~= nil) then
		return;
	end
	owner.buff = type;
	owner.atk_phy = owner.atk_phy + owner.atk_phy * m_dateBase[type].atk_phy;
	owner.atk_psy = owner.atk_psy + owner.atk_psy * m_dateBase[type].atk_psy;
	owner.def_phy = owner.def_phy + owner.def_phy * m_dateBase[type].def_phy;
	owner.def_psy = owner.def_psy + owner.def_psy * m_dateBase[type].def_psy;
	owner["actor"]:createTimer(m_dateBase[type].time, autoClearBuff);
end

function clearBuff(owner, type)
	if (owner.buff ~= type) then
		return;
	end
	owner.buff = nil;
	owner.atk_phy = owner.atk_phy - owner.atk_phy * m_dateBase[type].atk_phy;
	owner.atk_psy = owner.atk_psy - owner.atk_psy * m_dateBase[type].atk_psy;
	owner.def_phy = owner.def_phy - owner.def_phy * m_dateBase[type].def_phy;
	owner.def_psy = owner.def_psy - owner.def_psy * m_dateBase[type].def_psy;
end

function autoClearBuff(owner)
	local heroLua = HeroManager.getActorLua(owner);
	clearBuff(heroLua, heroLua.buff);
end
