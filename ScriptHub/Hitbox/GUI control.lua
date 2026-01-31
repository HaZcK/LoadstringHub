-- [[ FILE 1: GUI CONTROL & LOADER ]] --
-- Script ini bertugas membuat tampilan dan simulasi loading

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. Bersihkan GUI lama jika ada (Biar gak numpuk)
if LocalPlayer.PlayerGui:FindFirstChild("GeminiInterface") then
    LocalPlayer.PlayerGui.GeminiInterface:Destroy()
end

-- 2. Setup UI Utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiInterface"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainBoard"
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true -- Biar rapi
mainFrame.Parent = screenGui

-- Tambahan: Garis Pinggir (Stroke) biar elegan
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 40)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- 3. Kredit RGB
local credit = Instance.new("TextLabel")
credit.Name = "CreditTitle"
credit.Size = UDim2.new(1, -10, 0, 20)
credit.Position = UDim2.new(0, 0, 0, 5)
credit.Text = "Power By: Gemini"
credit.TextSize = 11
credit.Font = Enum.Font.GothamBold
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = mainFrame

spawn(function()
    local t = 0
    while wait() do
        t = t + 0.005
        credit.TextColor3 = Color3.fromHSV(t % 1, 0.7, 1)
    end
end)

-- 4. Status Loading
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusText"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.Text = "Initializing..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = mainFrame

-- 5. Tombol (Awalnya Mati/Non-Aktif)
local actionBtn = Instance.new("TextButton")
actionBtn.Name = "InjectButton"
actionBtn.Size = UDim2.new(0.85, 0, 0, 35)
actionBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
actionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
actionBtn.Text = "WAITING..."
actionBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
actionBtn.Font = Enum.Font.GothamBold
actionBtn.TextSize = 14
actionBtn.AutoButtonColor = false
actionBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = actionBtn

-- [[ PROSES SCANNING & LOAD FILE 2 ]] --
spawn(function()
    wait(1)
    for i = 0, 100, math.random(2, 8) do
        statusLabel.Text = "Scanning Hitbox... " .. i .. "%"
        wait(math.random(0.05, 0.2))
    end
    
    statusLabel.Text = "INJECTING SCRIPT..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50) -- Kuning
    wait(0.5)

    -- === DISINI KEHEBATANNYA ===
    -- Kita panggil script logic (File 2)
    -- GANTI LINK DI BAWAH DENGAN LINK RAW FILE 'HitboxSetting.lua' KAMU!
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/HitboxSetting.lua"))()
    end)

    if not success then
        statusLabel.Text = "FAILED TO LOAD!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        warn("Error Loading Script: " .. err)
    end
end)
