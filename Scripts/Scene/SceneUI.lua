module("SceneUI", package.seeall)

local m_hpBar = nil;
local m_spBar = nil;
local m_timeBar = nil;
local m_timeBottom = nil;
local m_missionDesc = nil;
local m_skillImg = nil;
local m_skillImgDis = nil;
local m_skillBtn = nil;
local m_missionLine = nil;
local m_curMissionNumber = nil;
local m_missionNumberMax = nil;
local m_skillIndex = nil;
local m_hat = nil;
local isTimeBarBlink = nil;
local m_missionFrame = nil;

local function freeAll()
	m_hpBar = nil;
    m_spBar = nil;
    m_timeBar = nil;
    m_timeBottom = nil;
    m_missionDesc = nil;
    m_skillImg = nil;
    m_skillImgDis = nil;
    m_skillBtn = nil;
    m_missionLine = nil;
    m_curMissionNumber = nil;
    m_missionNumberMax = nil;
    m_hat = nil;
    isTimeBarBlink = nil;
    m_missionFrame = nil;
end

local function initScene(sceneID)
	
end

function timeBarBlink(duration, uBlinks)
    isTimeBarBlink = true;
    local array = CCArray:create();
    array:addObject(CCBlink:create(duration, uBlinks));
    array:addObject(CCCallFunc:create(function() SceneUI.setTimeBarBlinkFlag() end));
    tolua.cast(m_timeBar, "CCNode"):runAction( CCSequence:create(array) );
end

function timeBarNoBlink()
    tolua.cast(m_timeBar, "CCNode"):stopAllActions();
    isTimeBarBlink = nil;
end

function getIsTimeBarBlink()
    return isTimeBarBlink;
end

function setTimeBarBlinkFlag()
    if(isTimeBarBlink == true)then
        isTimeBarBlink = nil;
    end 
end

local function pauseGame()
    local layer = getSceneLayer(SCENE_UI_LAYER);
    layer:onExit();
    SceneManager.pauseGame();
end

function setHatVisible(isVisible)
    if(m_hat == nil) then 
        return;
    end
    m_hat:setVisible(isVisible);
end

function hatBlink()
    local function hatBlinkEnd()
        -- local pos = tolua.cast(m_hat, "CCNode"):getPosition();
        local pos = ccp(m_hat:getPositionX(), m_hat:getPositionY());
        ParticleSysManager.createParticle( "missionFinishEffect", pos, 2 );
    end

    local array = CCArray:create();
    array:addObject(CCScaleTo:create(0.5, 2.0));
    array:addObject(CCScaleTo:create(0.3, 1.0));
    array:addObject(CCCallFunc:create(function() hatBlinkEnd() end));
    tolua.cast(m_hat, "CCNode"):runAction( CCSequence:create(array) );
end

function create(leader)
	initScene(sceneID);

    local uiLayer = getSceneLayer(SCENE_UI_LAYER);
    uiLayer:setTouchEnabled(true);

    local leaderData = HeroData.getData(leader);
    local skillID = leaderData["skill"];
    local skillIcon = SkillData.getSkillIcon(skillID);

    local hpFrame = CCSprite:create(PATH_RES_IMG_UI .. "hp_frame.png");
    local hpBar = ClipSprite:create(PATH_RES_IMG_UI .. "hp_bar.png");
    local leaderImg = CCSprite:create(PATH_RES_IMG_UI .. "leader_head_" .. leader .. ".png");
    local timeBar = ClipSprite:create(PATH_RES_IMG_UI .. "time_bar.png");
    local timeBottom = CCSprite:create(PATH_RES_IMG_UI .. "time_bottom.png");

    local missionFrame = CCSprite:create(PATH_RES_IMG_UI .. "mission_frame.png");
    local skill = CCSprite:create(PATH_RES_IMG_UI .. skillIcon ..".png");
    local skillEnable = ClipSprite:create(PATH_RES_IMG_UI .. skillIcon .. "_enable.png");
    local btnImg = CCSprite:create(PATH_RES_IMG_UI .. skillIcon .. "_enable.png");
    local btnImgSel = CCSprite:create(PATH_RES_IMG_UI .. skillIcon .. "_select.png");
    local btnSkill = CCMenuItemSprite:create(btnImg, btnImgSel);
    local menu = CCMenu:create();

    local desc = CCLabelTTF:create("", "karakusaAA", 38);
    local missionLine = CCSprite:create(PATH_RES_IMG_UI .. "mission_line.png");
    local numberCur = CCLabelTTF:create("", "karakusaAA", 48);
    local numberMax = CCLabelTTF:create("", "karakusaAA", 48);

    local pauseImg = CCScale9Sprite:create(PATH_RES_IMG_UI .. "pause.png");
    local pauseBtn = CCControlButton:create(pauseImg);
    local hat = CCSprite:create(PATH_RES_IMG_UI .. "hat.png");

    menu:addChild(tolua.cast(btnSkill, "CCNode"));
    btnSkill:registerScriptTapHandler(useSkill);

    tolua.cast(hpBar, "CCNode"):setAnchorPoint(CCPoint(0, 1));
    tolua.cast(hpBar, "CCNode"):setPosition(CCPoint(321, 1424));
    leaderImg:setAnchorPoint(CCPoint(0.5, 0.5));
    leaderImg:setPosition(CCPoint(250, 1380));
    hpFrame:setAnchorPoint(CCPoint(0, 1));
    hpFrame:setPosition(CCPoint(80, 1476));


    tolua.cast(timeBar, "CCNode"):setAnchorPoint(CCPoint(0.5, 0.5));
    tolua.cast(timeBar, "CCNode"):setPosition(CCPoint(1702.2, 1342.2));
    tolua.cast(timeBottom, "CCNode"):setAnchorPoint(CCPoint(0.5, 0.5));
    tolua.cast(timeBottom, "CCNode"):setPosition(CCPoint(1705.2, 1340.2));
   
    missionFrame:setAnchorPoint(CCPoint(0.5, 0.5));
    missionFrame:setPosition(CCPoint(1803.7, 1358.8));

    skill:setAnchorPoint(CCPoint(0.5, 0.5));
    skill:setPosition(CCPoint(1900, 130));
    tolua.cast(skillEnable, "CCNode"):setAnchorPoint(CCPoint(0.5, 0.5));
    tolua.cast(skillEnable, "CCNode"):setPosition(CCPoint(1900, 130));
    tolua.cast(btnImg, "CCNode"):setAnchorPoint(CCPoint(0, 0));
    tolua.cast(btnImgSel, "CCNode"):setAnchorPoint(CCPoint(0, 0));
    tolua.cast(btnSkill, "CCNode"):setAnchorPoint(CCPoint(0.5, 0.5));
    tolua.cast(menu, "CCNode"):setAnchorPoint(CCPoint(0, 0));
    tolua.cast(menu, "CCNode"):setPosition(CCPoint(1900, 130));
   
    numberCur:setColor(ccc3(0, 0, 0));
    numberCur:setAnchorPoint(CCPoint(0.5, 0.5));
    numberCur:setPosition(CCPoint(1810.9, 1311.1));
    tolua.cast(missionLine, "CCNode"):setAnchorPoint(CCPoint(0.5, 0.5));
    tolua.cast(missionLine, "CCNode"):setScale(0.8);
    tolua.cast(missionLine, "CCNode"):setPosition(CCPoint(1862.5, 1304.1));
    numberMax:setColor(ccc3(0, 0, 0));
    numberMax:setAnchorPoint(CCPoint(0.5, 0.5));
    numberMax:setPosition(CCPoint(1914.5, 1311.1));
    tolua.cast(desc, "CCNode"):setAnchorPoint(ccp(0.5, 0.5));
    tolua.cast(desc, "CCNode"):setPosition(CCPoint(1855, 1380));
    tolua.cast(desc, "CCNode"):setColor(ccc3(0, 0, 0));

    pauseBtn:setPosition(CCPoint(175, 1300));
    pauseBtn:setPreferredSize(CCSize(137, 126));
    pauseBtn:addHandleOfControlEvent(pauseGame, CCControlEventTouchUpInside);
    hat:setAnchorPoint(CCPoint(0.5, 0.5));
    hat:setPosition(CCPoint(1820, 1445));

    uiLayer:addChild(tolua.cast(hpBar, "CCNode"), 0);
    uiLayer:addChild(hpFrame, 1);
    uiLayer:addChild(leaderImg, 0);

    uiLayer:addChild(tolua.cast(timeBar, "CCNode"), 0);
    uiLayer:addChild(tolua.cast(timeBottom, "CCNode"), -1);

    uiLayer:addChild(missionFrame, 1);
    uiLayer:addChild(tolua.cast(hat, "CCNode"), 3);
    uiLayer:addChild(tolua.cast(desc, "CCNode"), 2);
    uiLayer:addChild(missionLine, 2);
    uiLayer:addChild(numberCur, 2);
    uiLayer:addChild(numberMax, 2);

    uiLayer:addChild(tolua.cast(menu, "CCNode"), 0);
    uiLayer:addChild(pauseBtn, 1);
    uiLayer:addChild(tolua.cast(skillEnable, "CCNode"), 1);
    uiLayer:addChild(skill, 0);

    m_hpBar = hpBar;
    m_spBar = skillEnable;
    m_timeBar = timeBar;
    m_missionDesc = desc;
    m_missionFrame = tolua.cast(missionFrame, "CCNode");
    m_skillImg = tolua.cast(skillEnable, "CCNode");
    m_skillImgDis = tolua.cast(skill, "CCNode");
    m_skillBtn = btnSkill;
    m_missionLine = tolua.cast(missionLine, "CCNode");
    m_curMissionNumber = tolua.cast(numberCur, "CCNode");
    m_missionNumberMax = tolua.cast(numberMax, "CCNode");
    m_hat = hat;
    isTimeBarBlink = false;

    btnSkill:setEnabled(false);
    tolua.cast(m_skillBtn, "CCNodeRGBA"):setOpacity(0);
    
    --setMissionNumberVisible(false);
    setHatVisible(false);
    uiLayer:scheduleUpdateWithPriorityLua(update, 2);
end

function remove()
	freeAll();

	local uiLayer = getSceneLayer(SCENE_UI_LAYER);
    uiLayer:unscheduleUpdate();
	uiLayer:removeAllChildrenWithCleanup(true);
end

function setSkillIndex(id)
    m_skillIndex = SkillData.getSkillIndex(id);
end

function setHPPercent(percent)
    percent = math.min(math.max(0, percent), 1);
	m_hpBar:setWidth(percent);
end

function setSPPercent(percent)
    percent = math.min(math.max(0, percent), 1);
    m_spBar:setHeight(math.max(0, percent));
end

function setTimePercent(percent)
    percent = math.min(math.max(0, percent), 1);
    m_timeBar:setHeight(math.max(0, percent));
end

function setMissionDesc(desc)
    m_missionDesc:setString(desc);
end

function setMissionNumberCur(cur)
    m_curMissionNumber:setString("" .. cur);
end

function setMissionNumberMax(max)
    m_missionNumberMax:setString("" .. max);
end

function spFull()
    tolua.cast(m_skillBtn, "CCNodeRGBA"):setOpacity(255);
    m_skillBtn:setEnabled(true);
    m_skillImgDis:setVisible(false);
    m_skillImg:setVisible(false);
end

function update(time)
	local hp, hpMax = HeroManager.getHP();
    local sp, spMax = HeroManager.getSP();
    local time, timeMax = SceneManager.getMissionTime();
    setHPPercent(hp / hpMax);
    setSPPercent(sp / spMax);
    setTimePercent(time / timeMax);
end

function useSkill()
    local skill = HeroManager.useSkill(m_skillIndex);
    if (skill == "frost" or skill == "buff_defense" or skill == "dragon") then
        tolua.cast(m_skillBtn, "CCNodeRGBA"):setOpacity(0);
        m_skillBtn:setEnabled(false);
        m_skillImgDis:setVisible(true);
        m_skillImg:setVisible(true);
    end
end