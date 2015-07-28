require "config"

local s_scene = nil;

function createSceneLayer(scene)
    s_scene = scene;
    local bgLayer = CCLayer:create();
    local mainLayer = CCLayer:create();
    local uiLayer = CCLayer:create();
    local interface = CCLayer:create();
    local loading = CCLayer:create();
    scene:addChild(bgLayer, 0, SCENE_BG_LAYER);
    scene:addChild(mainLayer, 1, SCENE_MAIN_LAYER);
    scene:addChild(uiLayer, 3, SCENE_UI_LAYER);
    scene:addChild(interface, 4, SCENE_INTERFACE_LAYER);
    scene:addChild(loading, 5, SCENE_LOADING_LAYER);
end

function getSceneLayer(tag)
    local layer = s_scene:getChildByTag(tag);
    return tolua.cast(layer, "CCLayer");
end

function addSceneLayer(child, z, tag)
    s_scene:addChild(tolua.cast(child, "CCNode"), z, tag);
end