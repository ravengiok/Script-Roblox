local Update = require(script.Parent.NewUiStellar)

-- Buat window dengan tema custom
local Window = Update:Window({
    Size = UDim2.new(0, 650, 0, 500),
    TabWidth = 160,
    SubTitle = "Premium v5.0",
    Theme = "Blue"  -- Opsional: Default, Blue, Purple, Green, Dark
})

-- Buat tab
local MainTab = Window:Tab("Main", "rbxassetid://10734904596")

-- Tambah komponen
MainTab:Button("Click Me", function()
    Update:Notify("Button clicked!")
end)

MainTab:Toggle("Auto Farm", false, "Enable automatic farming", function(state)
    Update:Notify("Auto Farm: " .. (state and "ON" or "OFF"))
end)

local slider = MainTab:Slider("Volume", 0, 100, 50, function(value)
    Update:Notify("Volume: " .. value)
end)

local dropdown = MainTab:Dropdown("Weapon", {"Sword", "Axe", "Bow", "Staff"}, "Sword", function(selected)
    Update:Notify("Selected: " .. selected)
end)

-- Ganti tema runtime
Update:SetTheme("Purple")