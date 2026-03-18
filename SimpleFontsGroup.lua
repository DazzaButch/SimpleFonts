local lib = LibStub:NewLibrary("SimpleFonts-Group", 1)
if not lib then return end

function lib.new(parent, label, ...)
    local box = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    box:SetBackdrop({
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    box:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    if select('#', ...) > 0 then box:SetPoint(...) end

    if label then
        local fs = box:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("BOTTOMLEFT", box, "TOPLEFT", 16, 0)
        fs:SetText(label)
    end
    return box
end