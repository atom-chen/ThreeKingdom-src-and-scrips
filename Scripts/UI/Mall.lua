module("Mall", package.seeall)

-- 保存界面所有变量的表
-- 界面是否被打开
local m_isOpen = false;

local m_mall = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 主层
local m_mallLayer_1 = nil;
-- 人物描述层
local m_mallLayer_2 = nil;
-- 界面是否被打开
local m_isOpen = false;

local m_portrait = nil;

local m_curChoiceId = nil;

local flag = 0;

local CAOCAO = 28;
local GUANYU = 22;

local BUYMONEYID_1 = 1;
local BUYMONEYID_2 = 2;
local m_tokePrice = { 99, 599 }; --代币价格
local m_tokenCount = { 9900, 59900 }; --能买到的代币数量

local CAOCAOID = 1;
local GUANYUID = 2;
local m_roleId = {28, 22};
local m_rolePrice = { 99, 49 }; --解锁人物价格

local BOXID_BUYWIN = 1;
local BOXID_NOMONEY = 2;
local BOXID_HAVEBUY = 3;

local function saveData()
	--保存数据：金币／代币／人物解锁情况
	DocManager.saveInt("money", PlayerInfo.getMoney());
	DocManager.saveInt("token", PlayerInfo.getToken());
	DocManager.saveBool("hero_enable_" .. CAOCAO, PlayerInfo.getHeroEnabled(CAOCAO));
	DocManager.saveBool("hero_enable_" .. GUANYU, PlayerInfo.getHeroEnabled(GUANYU));
end

local function refreshMoney()
	local money = PlayerInfo.getMoney();
	tolua.cast(m_mall.money, "CCLabelTTF"):setString("" .. money);
end

local function refreshYuanbao()
	local yuanbao = PlayerInfo.getToken();
	tolua.cast(m_mall.yuanbao, "CCLabelTTF"):setString("" .. yuanbao);
end

-- 按钮回调事件，自定义
local function closeOnClick()
    AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	saveData();
	Mall.close();
	UIManager.removeMallCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
	UIManager.loadMainMenuCCBI();
end

--初始化位置
local function initPosition()
	m_curChoiceId = -1;
	m_mallLayer_1:setPosition(ccp(1024, 660.0));
	m_mallLayer_2:setPosition(ccp(2320, 660.0));
end

--重置位置
local function rebuildPosition()
	if(flag == 0) then
		flag = 1;
		m_mallLayer_1:runAction(CCMoveTo:create(0.5, ccp(720.2, 660.0)));
		m_mallLayer_2:runAction(CCMoveTo:create(0.5, ccp(1465.2, 660.0)));
	end
end
--恢复位置
local function restorePosition()
	if(flag == 1) then
		flag = 0;
		m_mallLayer_1:runAction(CCMoveTo:create(0.5, ccp(1024, 660.0)));
		m_mallLayer_2:runAction(CCMoveTo:create(0.5, ccp(2320, 660.0)));
	end
end

local function showPortrait(portraitId)
	local name = PlayerInfo.getHeroName(portraitId);
	local portraitFrame = nil;
	portraitFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(name .. ".png");
    m_portrait:setDisplayFrame(portraitFrame);
end

local function getHeroAtk(name)
	local atkPhy = HeroData.getData(name).atk_phy;
	local atkPsy = HeroData.getData(name).atk_psy;
	if (atkPhy > atkPsy) then
		return atkPhy;
	else
		return atkPsy;
	end
end

local function getHeroDef(name)
	local defPhy = HeroData.getData(name).def_phy;
	local defPsy = HeroData.getData(name).def_psy;
	if (defPhy > defPsy) then
		return defPhy;
	else
		return defPsy;
	end
end

--进入充值
local function enterToShop()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	saveData();
	Confirm.close();
	Mall.close();
	Recharge.open();
end

local function closeBox()
	Confirm.close();
end

--显示提示框
local function showPromptBox(boxId)
	if(boxId == BOXID_BUYWIN) then
		Confirm.open(TEXT.buy_win);
		Confirm.setCallBackFunction(closeBox, closeBox);
	elseif(boxId == BOXID_NOMONEY) then
		Confirm.open(TEXT.money_not_enough);
		Confirm.setCallBackFunction(enterToShop, closeBox);
	elseif(boxId == BOXID_HAVEBUY) then
		Confirm.open(TEXT.have_buy);
		Confirm.setCallBackFunction(closeBox, closeBox);
	end
end

local function showProperty(portraitId)
	local skill = nil;
	--星级/主公技能
	if(portraitId == CAOCAO)then
		tolua.cast(m_mall.stars_4, "CCSprite"):setVisible(true);
		skill = TEXT.caocao_skill;
	else 
		tolua.cast(m_mall.stars_4, "CCSprite"):setVisible(false);
		skill = TEXT.none;
	end
	--攻／防／血/价格
	local name = PlayerInfo.getHeroName(portraitId);
	local atkValue = getHeroAtk(name);
	local defValue = getHeroDef(name);
	local hp = HeroData.getData(name).hp;
	local money = nil;
	if(portraitId == CAOCAO) then
		money = tolua.cast(m_mall.caocao_price_txt, "CCLabelTTF"):getString(); 
	else
		money = tolua.cast(m_mall.guanyu_price_txt, "CCLabelTTF"):getString(); 
	end

	tolua.cast(m_mall.gong, "CCLabelTTF"):setString(atkValue);
	tolua.cast(m_mall.fang, "CCLabelTTF"):setString(defValue);
	tolua.cast(m_mall.xue, "CCLabelTTF"):setString(hp);
	tolua.cast(m_mall.skill, "CCLabelTTF"):setString(skill);
end

local function showInfo(portraitId)
	showPortrait(portraitId);
	showProperty(portraitId);
end

local function caocaoPortraitOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	if(m_curChoiceId == -1) then
		m_curChoiceId = CAOCAO;
		rebuildPosition();
		showInfo(CAOCAO);
	elseif(m_curChoiceId == CAOCAO) then
		restorePosition();
		m_curChoiceId = -1;
	elseif(m_curChoiceId == GUANYU) then
		m_curChoiceId = CAOCAO;
		showInfo(CAOCAO);
	end
end

local function guanyuPortraitOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	if(m_curChoiceId == -1) then
		m_curChoiceId = GUANYU;
		rebuildPosition();
		showInfo(GUANYU);
	elseif(m_curChoiceId == GUANYU) then
		restorePosition();
		m_curChoiceId = -1;
	elseif(m_curChoiceId == CAOCAO) then
		m_curChoiceId = GUANYU;
		showInfo(GUANYU);
	end
end

local function buyMoneyByToken(buyId)
	if(PlayerInfo.getToken() >= m_tokePrice[buyId]) then
		PlayerInfo.modifyToken(-(m_tokePrice[buyId]));
		PlayerInfo.modifyMoney(m_tokenCount[buyId]);
		refreshMoney();
		refreshYuanbao();
		--提示购买成功
		showPromptBox(BOXID_BUYWIN);
	else
		--弹出提示是否进入充值界面
		showPromptBox(BOXID_NOMONEY);
	end
end

local function token1BuyOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	buyMoneyByToken(BUYMONEYID_1);
end

local function token2BuyOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	buyMoneyByToken(BUYMONEYID_2);
end

local function buyRoleBuyToken(roleId)
	if(PlayerInfo.getToken() >= m_rolePrice[roleId]) then
		PlayerInfo.modifyToken(-(m_rolePrice[roleId]));
		PlayerInfo.setHeroEnabled(m_roleId[roleId], true);
		refreshMoney();
		refreshYuanbao();
		--提示购买成功
		showPromptBox(BOXID_BUYWIN);
	else
		--弹出提示是否进入充值界面
		showPromptBox(BOXID_NOMONEY);
	end
end

local function caocaoBuyOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	if(PlayerInfo.getHeroEnabled(CAOCAOID) == false) then
		buyRoleBuyToken(CAOCAOID);
		showPortrait(CAOCAO);
	else
		showPromptBox(BOXID_HAVEBUY);
	end
end

local function guanyuBuyOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	if(PlayerInfo.getHeroEnabled(CAOCAOID) == false) then
		buyRoleBuyToken(GUANYUID);
		showPortrait(GUANYU);
	else
		showPromptBox(BOXID_HAVEBUY);
	end
end

local function restoreBtnOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	restorePosition();
	m_curChoiceId = -1;
end


-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["Mall"] = {};
	m_mall = ccb["Mall"];

	m_mall.closeOnClick = closeOnClick;
	m_mall.token1BuyOnClick = token1BuyOnClick;
	m_mall.token2BuyOnClick = token2BuyOnClick;
	m_mall.caocaoBuyOnClick = caocaoBuyOnClick;
	m_mall.guanyuBuyOnClick = guanyuBuyOnClick;
	m_mall.caocaoPortraitOnClick = caocaoPortraitOnClick; 
	m_mall.guanyuPortraitOnClick = guanyuPortraitOnClick;
	m_mall.restoreBtnOnClick = restoreBtnOnClick;
	m_mall.shopOnClick = enterToShop;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;

	m_mallLayer_1 = tolua.cast(m_mall.MallLayer_1, "CCLayer");
	m_mallLayer_2 = tolua.cast(m_mall.MallLayer_2, "CCLayer");
	m_portrait = tolua.cast(m_mall.portrait_img, "CCSprite");

	local restorePositionBtn = tolua.cast(m_mall.restorePositionBtn, "CCControlButton");
	m_portrait:removeFromParentAndCleanup(false);
	restorePositionBtn:addChild(m_portrait, 10);
end

-- 打开界面
function open()
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		m_parentId = parentId;
		initPosition();
		refreshMoney();
		refreshYuanbao();
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		if(flag == 1) then
			flag = 0;
		end
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:removeChild(m_rootLayer, false);
	end
end

-- 删除界面
function remove()
	if (m_rootLayer) then
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
		m_rootLayer:removeAllChildrenWithCleanup(true);
	end
	m_isOpen = false;
	m_mall  = nil;
	m_mallLayer_1 = nil;
	m_mallLayer_2 = nil;
	m_portrait = nil;
	m_rootLayer = nil;
	ccb["Mall"] = nil;
end