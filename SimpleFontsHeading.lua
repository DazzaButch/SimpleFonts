local lib = LibStub:NewLibrary("SimpleFonts-Heading", 1)
if not lib then return end

function lib.new(parent, text, subtext)
    local title = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(text or "")

    local subtitle = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetPoint("RIGHT", parent, "RIGHT", -32, 0)
    subtitle:SetText(subtext or "")

    return title, subtitle
end