local lib = LibStub:NewLibrary("SimpleFonts-AboutPanel", 1)
if not lib then return end

function lib.new(parent, addonname)
    local frame = CreateFrame("Frame", nil, UIParent)
    frame.name = parent and "About" or addonname
    frame.parent = parent
    frame.addonname = addonname
    frame:Hide()
    
    local category = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.parent)
    Settings.RegisterAddOnCategory(category)
    
    frame:SetScript("OnShow", function(self)
        local notes = C_AddOns.GetAddOnMetadata(self.addonname, "Notes")
        local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 16, -16)
        title:SetText(self.addonname.." - About")
        
        local sub = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
        sub:SetText(notes or "")
    end)
    return frame
end