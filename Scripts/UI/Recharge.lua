module("Recharge", package.seeall)

-- 保存界面所有变量的表
local m_recharge = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
--代币价格
local m_tokePrice = { 6, 12, 30, 68 };
--能买到的代币数量
local m_tokenCount = { 108, 2388, 788, 2388 };

-- 界面是否被打开
local m_isOpen = false;
--充值结果
local m_resultDesTxt = nil;
local m_resultDesBg = nil;

local function saveData()
	DocManager.saveInt("token", PlayerInfo.getToken());
	DocManager.flush();
end

local function refreshMoney()
	local money = PlayerInfo.getMoney();
	tolua.cast(m_recharge.money, "CCLabelTTF"):setString("" .. money);
end

local function refreshYuanbao()
	local yuanbao = PlayerInfo.getToken();
	tolua.cast(m_recharge.yuanbao, "CCLabelTTF"):setString("" .. yuanbao);
end

--显示充值结果。
function showResultBox(result)
	if(result == true) then
		m_resultDesTxt:setString("充值成功");
		refreshYuanbao();
		saveData();
	else
		m_resultDesTxt:setString("充值失败");
	end
	m_resultDesTxt:setVisible(true);
	m_resultDesBg:setVisible(true);

end

-- 按钮回调事件，自定义
local function closeOnClick()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
	saveData();
	Recharge.close();
	UIManager.removeRechargeCCBI();
	CCTextureCache:sharedTextureCache():removeUnusedTextures();
	UIManager.loadMainMenuCCBI();
end

local function buyOnClick(desc, button)
	local clickButton = tolua.cast(button, "CCControlButton");
	local id = clickButton:getTag();

    -- IAPManager.startTransaction(id);
end

local function enterToMall()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
	saveData();
	Confirm.close();
	Recharge.close();
	Mall.open();
end

local function onTouchBegan(x, y)
	if(m_resultDesBg and m_resultDesTxt) then
		m_resultDesBg:setVisible(false);
		m_resultDesTxt:setVisible(false);
	end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

local function addResultDesBox()
	m_resultDesTxt = CCLabelTTF:create("充值成功", "karakusaAA", 60);
	m_resultDesBg = CCSprite:create( PATH_CCB_ROOT .. "shop_frame_bg.png" );

	m_resultDesTxt:setColor(ccc3(255, 255, 255));
	m_resultDesTxt:setAnchorPoint(CCPoint(0.5, 0.5));
	m_resultDesTxt:setPosition(CCPoint(SCREEN_WIDTH/2, SCREEN_HEIGHT/2));
	m_resultDesBg:setAnchorPoint(CCPoint(0.5, 0.5));
	m_resultDesBg:setPosition(CCPoint(SCREEN_WIDTH/2, SCREEN_HEIGHT/2));

	m_rootLayer:addChild(m_resultDesBg, 10);
	m_rootLayer:addChild(m_resultDesTxt, 11);


	m_resultDesBg:setVisible(false);
	m_resultDesTxt:setVisible(false);
end


-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["Recharge"] = {};
	m_recharge = ccb["Recharge"];
	m_recharge.buyOnClick = buyOnClick;
	m_recharge.closeOnClick = closeOnClick;
	m_recharge.mallOnClick = enterToMall;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
    m_rootLayer:setTouchEnabled(true)
	m_rootLayer:registerScriptTouchHandler(onTouch)
	addResultDesBox();
end

-- 打开界面
function open()
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
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
	m_rootLayer = nil;
	ccb["Recharge"] = nil;
end