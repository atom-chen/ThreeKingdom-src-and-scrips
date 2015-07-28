module("Confirm", package.seeall)

-- 保存界面所有变量的表
local m_confirm = nil;
-- 根节点node，用于添加到Scene中
local m_rootLayer = nil;
-- 界面是否被打开
local m_isOpen = false;
-- 文字控件
local m_contentLabel = nil;
-- 按钮回调函数
local m_confirmCB = nil;
local m_cancelCB = nil;

-- 按钮回调事件，自定义
local function confirmOnClick()
	if (m_confirmCB) then
		m_confirmCB();
	else
		Confirm.close();
	end
end

local function cancelOnClick()
	if (m_cancelCB) then
		m_cancelCB();
	else
		Confirm.close();
	end
end

function setCallBackFunction(confirmCB, cancelCB)
	if (confirmCB) then
		m_confirmCB = confirmCB;
	end
	if (cancelCB) then
		m_cancelCB = cancelCB;
	end
end

-- 以下为协议函数，各界面都要实现

-- 创建界面
function create()
	ccb["Confirm"] = {};
	m_confirm = ccb["Confirm"];
	m_confirm.confirmOnClick = confirmOnClick;
	m_confirm.cancelOnClick = cancelOnClick;
end

-- 获取根节点node
function setLayer(layer)
	m_rootLayer = layer;
	m_contentLabel = tolua.cast(m_confirm.content, "CCLabelTTF");
end

-- 打开界面
function open(text)
	if (not m_isOpen) then
		m_isOpen = true;
		local layer = getSceneLayer(SCENE_UI_LAYER);
		layer:addChild(m_rootLayer);
		m_contentLabel:setString(text);
	end
end

-- 关闭界面
function close()
	if (m_isOpen) then
		m_isOpen = false;
		m_contentLabel:setString("");
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
	m_confirm  = nil;
	m_rootLayer = nil;
	ccb["Confirm"] = nil;
end