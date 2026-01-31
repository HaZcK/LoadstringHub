-- [[ FILE 2: HITBOX LOGIC & SETTING ]] --
-- Script ini berisi logika bypass dan distance check

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. Cari GUI yang sudah dibuat oleh File 1
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local uiInterface = playerGui:WaitForChild("GeminiInterface", 5)

if not uiInterface then
    warn("GUI Utama tidak ditemukan! Jalankan GuiControl.lua dulu.")
    return
end

local mainFrame = uiInterface:WaitForChild("MainBoard")
local statusLabel = mainFrame:WaitForChild("StatusText")
local actionBtn = mainFrame:WaitForChild("InjectButton")

-- 2. Update Tampilan Jadi "Ready"
statusLabel.Text = "SYSTEM READY"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100) -- Hijau Neon

actionBtn.Text = "HITBOX: OFF"
actionBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 3. Variabel Logika
local isActive = false
local reachDistance = 25 -- Jarak efektif (Studs)
local headSize = 10      -- Ukuran kepala saat aktif

-- 4. Fungsi Reset (Mengembalikan kepala ke normal)
local function resetHeads()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Size = Vector3.new(2, 1, 1) -- Ukuran default Roblox
            p.Character.Head.Transparency = 0
            p.Character.Head.CanCollide = true
        end
    end
end

-- 5. Logic Tombol (Toggle)
actionBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        actionBtn.Text = "HITBOX: ON"
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau
        statusLabel.Text = "DISTANCE CHECK: ACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
    else
        actionBtn.Text = "HITBOX: OFF"
        actionBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah
        statusLabel.Text = "SYSTEM READY"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        resetHeads() -- Reset saat dimatikan
    end
end)

-- 6. Loop Utama (Jantung Script)
RunService.RenderStepped:Connect(function()
    if isActive then
        for _, p in pairs(Players:GetPlayers()) do
            -- Cek validitas karakter musuh
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
                
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    -- Hitung Jarak
                    local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    
                    if dist <= reachDistance then
                        -- Jika DEKAT: Perbesar
                        p.Character.Head.Size = Vector3.new(headSize, headSize, headSize)
                        p.Character.Head.Transparency = 0.6
                        p.Character.Head.CanCollide = false
                    else
                        -- Jika JAUH: Normalkan
                        p.Character.Head.Size = Vector3.new(2, 1, 1)
                        p.Character.Head.Transparency = 0
                        p.Character.Head.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- Reset jika pemain mati/respawn agar tidak nge-bug
LocalPlayer.CharacterAdded:Connect(function()
    isActive = false
    actionBtn.Text = "HITBOX: OFF"
    actionBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    resetHeads()
end)
