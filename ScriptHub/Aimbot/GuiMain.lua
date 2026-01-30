-- [[ GUI.LUA - MODERN & ELEGANT STYLE ]] --
local Gui = {}

function Gui:CreateAimbotUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Aimbot_System"
    sg.IgnoreGuiInset = true -- Supaya bener-bener di tengah layar
    sg.ResetOnSpawn = false

    -- 🎯 1. CROSSHAIR (Bulat + Tanda +)
    local crosshairFrame = Instance.new("Frame")
    crosshairFrame.Name = "Crosshair"
    crosshairFrame.Size = UDim2.new(0, 40, 0, 40)
    crosshairFrame.Position = UDim2.new(0.5, -20, 0.5, -20)
    crosshairFrame.BackgroundTransparency = 1
    crosshairFrame.Parent = sg

    -- Lingkaran Luar
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BackgroundTransparency = 0.8
    circle.Parent = crosshairFrame
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.fromRGB(255, 140, 0)
    circleStroke.Thickness = 1.5
    circleStroke.Parent = circle

    -- Tanda + (Garis Horizontal)
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(0, 14, 0, 2)
    hLine.Position = UDim2.new(0.5, -7, 0.5, -1)
    hLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hLine.BorderSizePixel = 0
    hLine.Parent = crosshairFrame

    -- Tanda + (Garis Vertikal)
    local vLine = hLine:Clone()
    vLine.Size = UDim2.new(0, 2, 0, 14)
    vLine.Position = UDim2.new(0.5, -1, 0.5, -7)
    vLine.Parent = crosshairFrame

    -- 📟 2. AIMBOT CONTROL PANEL
    local aimFrame = Instance.new("Frame")
    aimFrame.Name = "AimbotControl"
    aimFrame.Size = UDim2.new(0, 200, 0, 120)
    aimFrame.Position = UDim2.new(0.02, 0, 0.7, 0) -- Di pojok kiri bawah
    aimFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    aimFrame.BackgroundTransparency = 0.2
    aimFrame.Parent = sg

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = aimFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 140, 0)
    uiStroke.Thickness = 2
    uiStroke.Parent = aimFrame

    -- Judul Menu
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "AIMBOT SETTINGS"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Parent = aimFrame

    -- Tombol On/Off
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleAimbot"
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.SourceSans
    toggleBtn.TextSize = 18
    toggleBtn.Parent = aimFrame

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    return sg, toggleBtn, crosshairFrame
end

return Gui
