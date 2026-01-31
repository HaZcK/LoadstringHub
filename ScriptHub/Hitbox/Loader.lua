-- [[ GEMINI EXECUTOR: GUI LOADER ]] --
-- Copy script ini ke Executor kamu

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Bersihkan GUI lama biar gak numpuk
if LocalPlayer.PlayerGui:FindFirstChild("GeminiInterface") then
    LocalPlayer.PlayerGui.GeminiInterface:Destroy()
end

-- 2. Buat Tampilan Utama (Wadah)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiInterface"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainBoard"
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Hiasan Garis & Sudut
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 40)
stroke.Thickness = 1.5
stroke.Parent = mainFrame
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- 3. Judul "Power By: Gemini"
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -10, 0, 20)
credit.Position = UDim2.new(0, 0, 0, 5)
credit.Text = "Power By: Gemini"
credit.TextSize = 11
credit.Font = Enum.Font.GothamBold
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = mainFrame

-- Efek Warna-warni
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

-- 5. Tombol (Placeholder)
local actionBtn = Instance.new("TextButton")
actionBtn.Name = "InjectButton"
actionBtn.Size = UDim2.new(0.85, 0, 0, 35)
actionBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
actionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
actionBtn.Text = "WAITING..."
actionBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
actionBtn.Font = Enum.Font.GothamBold
actionBtn.AutoButtonColor = false
actionBtn.Parent = mainFrame
Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 6)

-- [[ PROSES EKSEKUSI ]] --
spawn(function()
    wait(0.5)
    -- Animasi Scanning
    for i = 0, 100, math.random(5, 15) do
        statusLabel.Text = "Scanning Hitbox... " .. i .. "%"
        wait(0.05)
    end
    
    statusLabel.Text = "INJECTING SCRIPT..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    wait(0.5)

    -- === PENTING: GANTI LINK DI BAWAH INI ===
    -- Masukkan link RAW dari file HitboxSetting.lua kamu di dalam tanda kutip!
    
    local scriptUrl = "https://raw.githubusercontent.com/USERNAME/REPO/main/HitboxSetting.lua"
    
    -- Cek jika link masih default
    if scriptUrl == "https://raw.githubusercontent.com/USERNAME/REPO/main/HitboxSetting.lua" then
        statusLabel.Text = "LINK ERROR!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("LUPA GANTI LINK GITHUB WOY!")
        return
    end

    -- Jalankan Script Logic
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)

    if not success then
        statusLabel.Text = "FAILED!"
        warn("Error: " .. err)
    end
end)

