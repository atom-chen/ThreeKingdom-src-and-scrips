module("Help", package.seeall)

local ITEM_DISTANCE = 1024
local ITEM_DISTANCE_HALF = ITEM_DISTANCE * 0.5
local ITEM_COUNT = 9
-- 保存界面所有变量的表
local m_help = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
-- 滚动列表
local m_helpList = nil;
-- 下方小点
local m_slot = {};

local m_scrollLayer = nil;

local m_scrollView = nil;
-- 当前面板
local m_curSelect = 1;

-- 按钮回调事件，自定义
local function returnToSetting()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_BACK, false);
    Help.close();
    setting.open();
end

local function setCurSlot(index)
	if (m_curSelect == index) then
		return;
	end
	local texture1 = CCTextureCache:sharedTextureCache():addImage(PATH_CCB_ROOT .. "dot1.png");
	local texture2 = CCTextureCache:sharedTextureCache():addImage(PATH_CCB_ROOT .. "dot2.png");
	m_slot[index]:setTexture(texture1);
	m_slot[m_curSelect]:setTexture(texture2);
end

local function zoomItem(index, offset)
	local rate = math.abs((ITEM_DISTANCE * (index - 1) - offset) / ITEM_DISTANCE_HALF);
	local opacity = 255 * rate * 0.3;
	m_scrollItems[index]:setScale(1 - rate * 0.2);
	tolua.cast(m_scrollItems[index]:getChildByTag(1), "CCSprite"):setOpacity(255 - opacity);
	tolua.cast(m_scrollItems[index]:getChildByTag(2), "CCSprite"):setOpacity(255 - opacity);
end

local function onScroll()
	local offset = -m_helpList:getContentOffset().x;
	local curSelect = math.floor((offset + ITEM_DISTANCE_HALF) / ITEM_DISTANCE) + 1;
	curSelect = math.max(math.min(curSelect, ITEM_COUNT), 1);
	print("curSelect: " .. curSelect);
	setCurSlot(curSelect);
	zoomItem(curSelect, offset);
	m_curSelect = curSelect;
end

local function scrollStopped(desc)
	if (desc ~= "true") then
		return;
	end
	local posX = -m_helpList:getContentOffset().x;
	local offset = posX % ITEM_DISTANCE;
	if (offset ~= 0) then
		local offsetNext = ITEM_DISTANCE - offset;
		if (offsetNext < offset) then
			offset = -offsetNext;
		end
		m_helpList:setContentOffset(CCPoint(-posX + offset, 0), true);
	end
end

local function registerCallBackFunction()
	m_helpList:registerScriptHandler(onScroll, 0);
	m_helpList:registerScriptHandler(scrollStopped, 2);
end

local function attachController()
	m_helpList = tolua.cast(m_help.helpList, "CCScrollView");
	for i = 1, ITEM_COUNT do
		m_slot[i] = tolua.cast(m_rootLayer:getChildByTag(i), "CCSprite");
		m_scrollItems[i] = m_scrollView["help_" .. i];
	end
end

-- 创建界面
function create()
	ccb["Help"] = {};
	m_help = ccb["Help"];
	m_help.backOnClick = returnToSetting;
	m_slot = {};

	ccb["HelpList"] = {};
	m_scrollView = ccb["HelpList"];
	m_scrollItems = {};
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
	attachController();
	registerCallBackFunction();
end

-- 打开界面
function open()
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:removeChild(m_rootLayer, false);
	end
end

-- 删除界面
function remove()
	if (m_rootLayer) then
		m_rootLayer:removeAllChildrenWithCleanup(true);
		getSceneLayer(SCENE_UI_LAYER):addChild(m_rootLayer);
	end
	m_isOpen = false;
	m_help = nil;
	m_rootLayer = nil;
	ccb["Help"] = nil;
	m_slot = nil;
	
	ccb["HelpList"] = nil;
	m_scrollView = nil;
	m_scrollItems = nil;
end