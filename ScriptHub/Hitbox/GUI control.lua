-- [[ GUI LOADER & SCANNER ]] --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiLoader"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 100)
main.Position = UDim2.new(0.5, -100, 0.5, -50)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 40)
status.Text = "Hitbox finding 0%"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.BackgroundTransparency = 1
status.Parent = main

-- Proses Scanning
spawn(function()
    for i = 0, 100, 5 do
        status.Text = "Hitbox finding " .. i .. "%"
        wait(0.1)
    end
    status.Text = "INJECTED!"
    status.TextColor3 = Color3.fromRGB(0, 255, 0)
    wait(0.5)
    
    -- MEMANGGIL FILE SETTING (Injeksi Fungsi Utama)
    -- Ganti URL di bawah dengan link RAW HitboxSetting.lua milikmu sendiri!
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/HitboxSetting.lua"))()
end)

