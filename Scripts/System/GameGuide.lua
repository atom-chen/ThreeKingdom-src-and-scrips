
module("GameGuide", package.seeall)

require "Exchange"
require "PlayerInfo"
require "HeroData"

local heroEnableGuideFinish = false;
local heroStrengGuideFinish = false;

local guideResName = "maobiguangquan";
local guideAniName = "stand2";

function getGuideResName()
	return guideResName;
end
function getGuideAnimName()
	return guideAniName;
end


function getHeroEnableFinish()
	return heroEnableGuideFinish;
end
function setHeroEnableFinish( isFinish )
	heroEnableGuideFinish = isFinish;
end

function getHeroStrengFinish()
	return heroStrengGuideFinish;
end
function setHeroStrengFinish( isFinish )
	heroStrengGuideFinish = isFinish;
end



--判断第一个可解锁的武将(张良)是否可解锁
function isHeroCanEnable()
	local zhangliangId = PlayerInfo.getHeroID("zhangliang");
	return (Exchange.checkIsEnabled(zhangliangId) and PlayerInfo.getHeroEnabled(zhangliangId) == false);
end

--判断第一个可强化的武将是否可强化
function isHeroCanStren()
	--判断"刘备"等级是否是一级、金钱是否足够
	local liubeiId = PlayerInfo.getHeroID("liubei");
	if(PlayerInfo.getHeroLevel(liubeiId) == 0) then
		if(PlayerInfo.getMoney() >= HeroData.getData("liubei_1").money) then
			return true;
		end
	end
	return false;
end

--装备人物引导
local function isUpgradeGuideFinish()
	return DocManager.loadBool("isUpgradeGuideFinish");
end

function canShowUpgradeGuide()
	local s = DocManager.loadBool("isUpgradeGuideFinish");
	if(s == false) then
		if(PlayerInfo.getHeroEnabled(9) == true) then
			return true;
		end
	end
	return false;
end

function setUpgradeFinsh()
	DocManager.saveBool("isUpgradeGuideFinish", true);
	DocManager.flush();
end




