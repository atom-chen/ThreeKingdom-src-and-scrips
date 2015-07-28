module("ParticleSysManager", package.seeall)

local m_defautName = "quan";
local m_defautScale = 1;

function createParticle( name, pos, scale, layer )
    local particle = nil;
    if(name ~= "") then
    	particle = CCParticleSystemQuad:create(PATH_RES_OTHER .. name .. ".plist");
    else
    	particle = CCParticleSystemQuad:create(PATH_RES_OTHER .. m_defautName .. ".plist");
    end

    if(scale ~= 0) then
    	particle:setScale(scale);
    else
    	particle:setScale(m_defautScale);
    end

    if(pos) then
    	particle:setPosition(pos);
    end
    if(layer) then
    	layer:addChild(particle, 10);
    else
	    local uiLayer = getSceneLayer(SCENE_UI_LAYER);
	    uiLayer:addChild(particle, 10);
    end
    return particle;
end


function createParticleSimple(name, pos, scale)
	local particle = nil;
    if(name ~= "") then
    	particle = CCParticleSystemQuad:create(PATH_RES_OTHER .. name .. ".plist");
    else
    	particle = CCParticleSystemQuad:create(PATH_RES_OTHER .. m_defautName .. ".plist");
    end
     if(scale ~= 0) then
    	particle:setScale(scale);
    else
    	particle:setScale(m_defautScale);
    end
    if(pos) then
    	particle:setPosition(pos);
    end
    return particle;
end


function getRotateAction()
	-- local arr = CCArray:create();
	local rotate = CCRotateBy:create(2, 400);
	-- local delay = CCDelayTime:create(0);
	-- arr:addObject(rotate);
	-- arr:addObject(delay);
	-- local seque = CCSequence:create(arr);
	local repeatForever = CCRepeatForever:create(rotate);
	return repeatForever;
end



