local addonName, ns = ...

-- ==========================================================
-- 1. DATABASE INITIALIZATION (Immediate)
-- ==========================================================
SimpleFontsDB = SimpleFontsDB or {
    selected = "Default"
}

-- ==========================================================
-- 2. FONT PACK REGISTRY
-- To add a new font: 
-- 1. Create a folder in /Fonts/ (e.g. /Fonts/Oswald/)
-- 2. Ensure files are named: FontName-Regular.ttf, FontName-Bold.ttf, 
--    FontName-BoldItalic.ttf, FontName-Italic.ttf
-- 3. Uncomment the two '--' and change 'Rename_Me_1' to the name 
--    Fonts in Folder in the list below.
-- ==========================================================
local FontPacks = {
    ["Default"]     = true,
    ["Arimo"]       = true,
    ["Barlow"]      = true,
    ["GoogleSans"]  = true,
    ["Roboto"]      = true,
    -- ["Rename_Me_1"] = true,
    -- ["Rename_Me_2"] = true,
}

local function GetPath(variant)
    local folder = SimpleFontsDB.selected or "Default"
    if folder == "Default" then return nil end
    return [[Interface\AddOns\SimpleFonts\Fonts\]]..folder..[[\]]..folder.."-"..variant..".ttf"
end

-- ==========================================================
-- 3. CORE APPLICATION LOGIC
-- ==========================================================
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if addon ~= "SimpleFonts" then return end

    local selectedFolder = SimpleFontsDB.selected or "Default"

    -- LSM Registration
    local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
    if LSM and selectedFolder ~= "Default" then
        LSM:Register("font", "SimpleFonts: "..selectedFolder, GetPath("Regular"))
    end

    -- FONT APPLY LOGIC (Only runs if NOT Default)
    if selectedFolder ~= "Default" then
        local function SetFont(obj, variant, forcedSize, style, r, g, b, sr, sg, sb, sox, soy)
            -- FIX: Check if obj exists AND if it's a type that supports fonts (FontStrings)
            if not obj or not obj.GetFont then return end
            
            local fontPath = GetPath(variant)
            if not fontPath then return end

            local _, curSize, curStyle = obj:GetFont()
            obj:SetFont(fontPath, forcedSize or curSize or 12, style or curStyle or "")

            if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
            if sox and soy then obj:SetShadowOffset(sox, soy) end
            if r and g and b then 
                obj:SetTextColor(r, g, b)
            elseif r then 
                obj:SetAlpha(r) 
            end
        end

        -- Base Engine Constants
        UNIT_NAME_FONT     = GetPath("Bold")
        NAMEPLATE_FONT     = GetPath("Bold")
        DAMAGE_TEXT_FONT   = GetPath("Bold")
        STANDARD_TEXT_FONT = GetPath("Bold")

        -- Main UI Elements
        SetFont(GameFontNormal, "Regular")
        SetFont(GameFontHighlight, "Regular")
        SetFont(GameFontDisable, "Regular")
        SetFont(SystemFont_Large, "Regular")
        SetFont(SystemFont_Med1, "Regular")
        SetFont(SystemFont_Med2, "Italic", nil, nil, 0.15, 0.09, 0.04)
        SetFont(SystemFont_Med3, "Regular")
        SetFont(SystemFont_Small, "Regular")
        SetFont(SystemFont_Tiny, "Regular")

        -- Questing, Tracking & Reputation
        SetFont(QuestFont_Large, "Regular")
        SetFont(QuestFont_Shadow_Small, "Regular")
        SetFont(QuestFont_Shadow_Huge, "Bold", nil, nil, nil, nil, nil, 0.54, 0.4, 0.1)
        SetFont(QuestFont_Super_Huge, "Bold")
        SetFont(QuestFont_Enormous, "Bold")
        SetFont(QuestFontNormalSmall, "Bold", nil, nil, nil, nil, nil, 0.54, 0.4, 0.1)
        SetFont(ObjectiveFont, "Regular")
        SetFont(QuestInfoRewardText, "Regular")
        SetFont(ReputationDetailFont, "Bold", nil, nil, nil, nil, nil, 0, 0, 0, 1, -1)

        -- Objective Tracker (Corrected to target .Text objects)
        SetFont(ObjectiveTrackerLineFont, "Regular")
        SetFont(ObjectiveTrackerHeaderFont, "Bold")
        
        for i = 12, 22 do
            local fontObj = _G["ObjectiveTrackerFont"..i]
            if fontObj then SetFont(fontObj, i >= 14 and "Bold" or "Regular") end
        end

        -- Targeting the specific text elements inside the frame, not the frame itself
        if ObjectiveTrackerFrame then
            if ObjectiveTrackerFrame.Header and ObjectiveTrackerFrame.Header.Text then 
                SetFont(ObjectiveTrackerFrame.Header.Text, "Bold", nil, "OUTLINE") 
            end
            if ObjectiveTrackerFrame.ContentsFrame and ObjectiveTrackerFrame.ContentsFrame.HeaderText then 
                SetFont(ObjectiveTrackerFrame.ContentsFrame.HeaderText, "Bold", nil, "OUTLINE") 
            end
        end

        if QuestObjectiveTracker and QuestObjectiveTracker.ContentsFrame then
            SetFont(QuestObjectiveTracker.ContentsFrame.HeaderText, "Bold", nil, "OUTLINE")
            SetFont(QuestObjectiveTracker.ContentsFrame.Text, "Regular")
        end

        -- Quest Log & NPC Interaction
        SetFont(QuestInfoTitleHeader, "Bold")
        SetFont(QuestInfoDescriptionHeader, "Bold")
        SetFont(QuestInfoObjectivesHeader, "Bold")
        SetFont(QuestInfoRewardsFrame.Header, "Bold")
        SetFont(QuestInfoDescriptionText, "Regular")
        SetFont(QuestInfoObjectivesText, "Regular")
        SetFont(QuestNPCModelNameText, "Bold", 13, "OUTLINE")
        SetFont(QuestNPCModelText, "Regular")

        if CampaignObjectiveTracker and CampaignObjectiveTracker.Header then
            SetFont(CampaignObjectiveTracker.Header.Text, "Bold", nil, "OUTLINE")
        end

        -- Adventure Guide Suggestion Fix
        local function ApplySuggestFix()
            if not EncounterJournalSuggestFrame then return end
            for i = 1, 3 do
                local frame = EncounterJournalSuggestFrame["Suggestion"..i]
                if frame and frame.centerDisplay and frame.centerDisplay.description then
                    local txt = frame.centerDisplay.description.text
                    SetFont(txt, "Regular", nil, "NONE", 0, 0, 0)
                    txt:SetShadowColor(0, 0, 0, 0)
                end
            end
        end

        if C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal") then
            ApplySuggestFix()
        else
            local journalWait = CreateFrame("Frame")
            journalWait:RegisterEvent("ADDON_LOADED")
            journalWait:SetScript("OnEvent", function(self, _, addon)
                if addon == "Blizzard_EncounterJournal" then
                    ApplySuggestFix()
                    self:UnregisterAllEvents()
                end
            end)
        end

        SetFont(AdventureGuide_RewardText, "Regular", nil, "NONE")
        SetFont(AdventureMap_MissionTextFont, "Regular", nil, "NONE")

        -- Tooltips, Social, & Chat
        SetFont(GameTooltipHeader, "Bold", nil, "OUTLINE")
        SetFont(Tooltip_Med, "Regular")
        SetFont(Tooltip_Small, "Bold")
        SetFont(FriendsFont_UserText, "Bold", nil, nil, nil, nil, nil, 0, 0, 0, 1, -1)
        SetFont(FriendsFont_Normal, "Regular", nil, nil, nil, nil, nil, 0, 0, 0, 1, -1)
        SetFont(ChatFontNormal, "Regular")

        -- Specialized Fonts
        SetFont(ErrorFont, "Italic", nil, nil, 60)
        SetFont(BossEmoteNormalHuge, "BoldItalic", nil, "THICKOUTLINE")
        SetFont(GameFont_Gigantic, "Bold", nil, nil, nil, nil, nil, 0, 0, 0, 1, -1)
        SetFont(WorldMapTextFont, "BoldItalic", nil, "THICKOUTLINE", 40, nil, nil, 0, 0, 0, 1, -1)

        -- Numbers & Outlines
        SetFont(SystemFont_OutlineThick_Huge2, "Regular", nil, "THICKOUTLINE")
        SetFont(NumberFont_Outline_Med, "Bold", nil, "OUTLINE")
        SetFont(NumberFont_Outline_Huge, "Bold", nil, "THICKOUTLINE", 30)

        for i=1, NUM_CHAT_WINDOWS or 10 do
            local cf = _G["ChatFrame"..i]
            if cf then
                local _, size, flags = cf:GetFont()
                cf:SetFont(GetPath("Regular"), size or 12, flags or "")
            end
        end
    end
end)

-- ==========================================================
-- 4. OPTIONS WINDOW (/sf)
-- ==========================================================
local options = CreateFrame("Frame", "SimpleFontsOptions", UIParent, "BackdropTemplate")
options:SetSize(220, 180)
options:SetPoint("CENTER")
options:SetFrameStrata("DIALOG")
options:SetMovable(true)
options:EnableMouse(true)
options:RegisterForDrag("LeftButton")
options:SetScript("OnDragStart", options.StartMoving)
options:SetScript("OnDragStop", options.StopMovingOrSizing)
options:Hide()

local backdropSettings = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

options:SetBackdrop(backdropSettings)
options:SetBackdropColor(0, 0, 0, 0.9)

local title = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", 0, -12)
title:SetText("SimpleFonts Settings")

local close = CreateFrame("Button", nil, options, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -2, -2)

local label = options:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
label:SetPoint("TOP", 0, -42)
label:SetText("Select Font")

local drop = CreateFrame("Frame", "SimpleFontsDrop", options, "UIDropDownMenuTemplate, BackdropTemplate")
drop:SetPoint("TOP", 0, -58)
UIDropDownMenu_SetWidth(drop, 140)

local name = drop:GetName()
_G[name.."Left"]:Hide()
_G[name.."Middle"]:Hide()
_G[name.."Right"]:Hide()

drop:SetBackdrop(backdropSettings)
drop:SetBackdropColor(0, 0, 0, 0.5)
drop:SetSize(170, 26)

local dropText = _G[name.."Text"]
dropText:ClearAllPoints()
dropText:SetPoint("CENTER", drop, "CENTER", -10, 0)
dropText:SetJustifyH("CENTER")

local dropButton = _G[name.."Button"]
dropButton:ClearAllPoints()
dropButton:SetPoint("RIGHT", drop, "RIGHT", -2, 0)

local function InitDropDown(self, level)
    local info = UIDropDownMenu_CreateInfo()
    local selected = SimpleFontsDB.selected or "Default"
    info.justifyH = "CENTER"
    
    local names = {}
    for k in pairs(FontPacks) do if k ~= "Default" then table.insert(names, k) end end
    table.sort(names)
    table.insert(names, 1, "Default")
    
    for _, name in ipairs(names) do
        info.text = name
        info.func = function()
            SimpleFontsDB.selected = name
            UIDropDownMenu_SetSelectedName(drop, name)
            UIDropDownMenu_SetText(drop, name)
            dropText:SetJustifyH("CENTER")
        end
        info.checked = (selected == name)
        UIDropDownMenu_AddButton(info)
    end
end

options:SetScript("OnShow", function()
    local selected = SimpleFontsDB.selected or "Default"
    UIDropDownMenu_Initialize(drop, InitDropDown)
    UIDropDownMenu_SetSelectedName(drop, selected)
    UIDropDownMenu_SetText(drop, selected)
    dropText:SetJustifyH("CENTER")
    
    C_Timer.After(0.01, function()
        local menu = _G["DropDownList1MenuBackdrop"] or _G["DropDownList1Backdrop"]
        if menu and menu.SetBackdrop then
            menu:SetBackdrop(backdropSettings)
            menu:SetBackdropColor(0, 0, 0, 0.9)
        end
    end)
end)

local save = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
save:SetSize(120, 24)
save:SetPoint("BOTTOM", 0, 20)
save:SetText("Save & Reload")
save:SetScript("OnClick", function() ReloadUI() end)

SLASH_SIMPLEFONTS1 = "/sf"
SlashCmdList["SIMPLEFONTS"] = function()
    options:SetShown(not options:IsShown())
end