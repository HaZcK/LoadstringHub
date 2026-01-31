-- 1. Setup Utama (Elegant Black Theme)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ElegantPlayerList"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- 2. Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Hitam Pekat
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Biar bisa digeser
mainFrame.Parent = screenGui

-- Efek Sudut Melengkung (Optional tapi bikin elegan)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- 3. Judul Atas
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "PREMIUM PLAYER LIST"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- 4. Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 2
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 5)

-- Fungsi Update List
local function updateList()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Baris Pemain
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 35)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        row.BorderSizePixel = 0
        row.Parent = scrollFrame
        
        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 5)
        rowCorner.Parent = row

        -- Nama Pemain
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.7, -10, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.Parent = row

        -- Tombol Kick
        local kickBtn = Instance.new("TextButton")
        kickBtn.Size = UDim2.new(0.3, -5, 0.8, 0)
        kickBtn.Position = UDim2.new(0.7, 0, 0.1, 0)
        kickBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah Gelap
        kickBtn.Text = "KICK"
        kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        kickBtn.Font = Enum.Font.GothamBold
        kickBtn.TextSize = 10
        kickBtn.Parent = row

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = kickBtn

        -- Fungsi Klik Kick
        kickBtn.MouseButton1Click:Connect(function()
            kickBtn.Text = "BERHASIL"
            kickBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Berubah Hijau
            wait(1)
            kickBtn.Text = "KICK"
            kickBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end)
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

game.Players.PlayerAdded:Connect(updateList)
game.Players.PlayerRemoving:Connect(updateList)
updateList()
