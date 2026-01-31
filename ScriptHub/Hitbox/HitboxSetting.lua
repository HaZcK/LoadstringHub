-- [[ GEMINI HITBOX V1 - BYPASS EDITION ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. Setup GUI (Elegant Black)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiBypassGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 110)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -55)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- 2. "Power By: Gemini" (RGB Effect)
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 100, 0, 20)
credit.Position = UDim2.new(1, -105, 0, 5)
credit.Text = "Power By: Gemini"
credit.TextSize = 10
credit.Font = Enum.Font.GothamBold
credit.BackgroundTransparency = 1
credit.Parent = mainFrame

spawn(function()
    local counter = 0
    while wait() do
        counter = counter + 0.01
        credit.TextColor3 = Color3.fromHSV(counter % 1, 0.7, 1)
    end
end)

-- 3. Tombol Hitbox
local hbBtn = Instance.new("TextButton")
hbBtn.Size = UDim2.new(0.85, 0, 0, 45)
hbBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
hbBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hbBtn.Text = "Hitbox: OFF"
hbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hbBtn.Font = Enum.Font.GothamBold
hbBtn.TextSize = 16
hbBtn.Parent = mainFrame

Instance.new("UICorner", hbBtn).CornerRadius = UDim.new(0, 8)

-- 4. Logic Bypass V1
local _G.HitboxEnabled = false
local _G.HitboxSize = 10 -- Ukuran besar (Bisa kamu ubah)

hbBtn.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = not _G.HitboxEnabled
    
    if _G.HitboxEnabled then
        hbBtn.Text = "Hitbox: ON"
        hbBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        hbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        hbBtn.Text = "Hitbox: OFF"
        hbBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        -- Reset Head ke normal
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(2, 1, 1)
                p.Character.Head.Transparency = 0
            end
        end
    end
end)

-- Loop Bypass (Berjalan di RenderStepped agar lebih cepat dari script Anti-Cheat)
RunService.RenderStepped:Connect(function()
    if _G.HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                -- Bypass V1: Mengunci size & menonaktifkan benturan fisik agar tidak terdeteksi 'Illegal Movement'
                head.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                head.Transparency = 0.6
                head.CanCollide = false
                head.Massless = true -- Menghilangkan berat part agar tidak merusak gravitasi
            end
        end
    end
end)

