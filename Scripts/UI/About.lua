module("About", package.seeall)

-- 保存界面所有变量的表
local m_about = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
--内容
local m_content = nil;
-- 界面是否被打开
local m_isOpen = false;

local x = nil;
local m_parentId = nil;


function initPosition()
	m_content:setPosition(CCPoint(x, 600));
end

local function move()
	local array = CCArray:create();
	array:addObject(CCMoveTo:create(25, CCPoint(x, SCREEN_HEIGHT + m_content:getContentSize().height )));
	array:addObject(CCCallFunc:create(function() About.initPosition() end));
	local action = CCRepeatForever:create(CCSequence:create(array));
	m_content:runAction(action);
end

local function onTouch()
	AudioEngine.playEffect(UIManager.PATH_EFFECT_CANIN, false);
    About.close();
    setting.open(m_parentId);
end

-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["About"] = {};
	m_about = ccb["About"];
	m_about.touchOnClick = onTouch;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
	m_content = tolua.cast(m_about.content, "CCNode");
	m_parentId = -1;
end

-- 打开界面
function open(parentId)
	if (not m_isOpen) then
		m_isOpen = true;
		m_parentId = parentId;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		x = SCREEN_WIDTH/2 - (m_content:getContentSize().width)/2;
		initPosition();
		move();
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		if(flag == 1) then
			flag = 0;
		end
		m_content:stopAllActions();
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
	ccb["About"] = nil;
end