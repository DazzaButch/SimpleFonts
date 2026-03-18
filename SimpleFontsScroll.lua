local lib = LibStub:NewLibrary("SimpleFonts-Scroll", 1)
if not lib then return end

function lib.new(parent, offset)
    local f = CreateFrame("Slider", nil, parent)
    f:SetWidth(16)
    f:SetOrientation("VERTICAL")
    f:SetPoint("TOPRIGHT", -(offset or 0), -16)
    f:SetPoint("BOTTOMRIGHT", -(offset or 0), 16)
    
    f:SetThumbTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
    local border = CreateFrame("Frame", nil, f, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop({edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 12})
    
    return f
end