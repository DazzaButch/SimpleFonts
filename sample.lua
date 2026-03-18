local frame = LibStub("SimpleFonts-AboutPanel").new(nil, "SimpleFonts")

-- 1. Create the Group Box (Atonement Style)
local group = LibStub("SimpleFonts-Group").new(frame, "Settings", "TOPLEFT", 16, -60)
group:SetPoint("RIGHT", -16, 0)
group:SetHeight(160)

-- 2. Label: Select Font
local label = group:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
label:SetPoint("TOPLEFT", 16, -25)
label:SetText("Select Font")

-- 3. The Dropdown Menu
local selection = CreateFrame("Frame", "SimpleFontsDropdown", group, "UIDropDownMenuTemplate")
selection:SetPoint("TOPLEFT", label, "BOTTOMLEFT", -15, -10)

UIDropDownMenu_SetWidth(selection, 160)
UIDropDownMenu_SetText(selection, (SimpleFontsDB and SimpleFontsDB.selected) or "Roboto")

UIDropDownMenu_Initialize(selection, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    
    -- This part is now dynamic - it looks at what you enabled in SimpleFonts.lua
    -- We use a sorted list so it stays alphabetical
    local packs = {"Arimo", "GoogleSans", "Roboto"} 
    
    for _, name in ipairs(packs) do
        info.text = name
        info.func = function()
            SimpleFontsDB = SimpleFontsDB or {}
            SimpleFontsDB.selected = name
            UIDropDownMenu_SetText(selection, name)
        end
        info.checked = (SimpleFontsDB and SimpleFontsDB.selected == name)
        UIDropDownMenu_AddButton(info)
    end
end)

-- 4. The Save & Reload Button
local btn = CreateFrame("Button", nil, group, "UIPanelButtonTemplate")
btn:SetSize(140, 30)
btn:SetPoint("TOPLEFT", selection, "BOTTOMLEFT", 20, -15)
btn:SetText("Save & Reload")

-- Tooltip Logic (Atonement style)
btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Save & Reload", 1, 1, 1)
    GameTooltip:AddLine("Pressing Save will force reload the UI to apply your font changes.", 1, 0.82, 0, true)
    GameTooltip:Show()
end)

btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

btn:SetScript("OnClick", function()
    ReloadUI()
end)