--[[ 
    REAL-TIME PLAYER MANAGER (ESP)
    Tema: Red & Orange 
    Karakteristik: Otomatis deteksi player baru & respawn
--]]

local PlayerManager = {}

-- Konfigurasi tampilan
PlayerManager.Enabled = true -- Set true agar langsung aktif saat script dijalankan
local FILL_COLOR = Color3.fromRGB(255, 0, 0)     -- Merah
local OUTLINE_COLOR = Color3.fromRGB(255, 140, 0) -- Orange

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fungsi utama untuk pasang Highlight
local function createHighlight(character)
    if not character then return end
    
    -- Tunggu sebentar supaya model karakter lengkap dimuat
    local humRoot = character:WaitForChild("HumanoidRootPart", 5)
    if not humRoot then return end

    -- Cek kalau sudah ada highlight lama, hapus dulu supaya tidak double
    local existing = character:FindFirstChild("Scanner_Highlight")
    if existing then existing:Destroy() end

    -- Buat Highlight baru
    local hl = Instance.new("Highlight")
    hl.Name = "Scanner_Highlight"
    hl.Adornee = character
    hl.FillColor = FILL_COLOR
    hl.OutlineColor = OUTLINE_COLOR
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tembus tembok
    hl.Parent = character
    
    -- Sinkronisasi dengan status On/Off saat ini
    hl.Enabled = PlayerManager.Enabled
end

-- Fungsi yang menangani setiap player
local function handlePlayer(player)
    if player == LocalPlayer then return end -- Jangan highlight diri sendiri

    -- 1. Cek karakter yang sudah ada saat ini
    if player.Character then
        createHighlight(player.Character)
    end

    -- 2. Pantau jika karakter respawn (mati lalu hidup lagi)
    player.CharacterAdded:Connect(function(char)
        createHighlight(char)
    end)
end

-- Jalankan fungsi utama
function PlayerManager:Start()
    -- Cek player yang sudah ada di server (Existing Players)
    for _, player in ipairs(Players:GetPlayers()) do
        handlePlayer(player)
    end

    -- Pantau player yang baru join (New Players)
    Players.PlayerAdded:Connect(function(newPlayer)
        print("[SYSTEM] Player baru terdeteksi: " .. newPlayer.Name)
        handlePlayer(newPlayer)
    end)
end

-- Fungsi untuk mematikan/menghidupkan ESP dari GUI
function PlayerManager:SetState(state)
    PlayerManager.Enabled = state
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            local hl = char:FindFirstChild("Scanner_Highlight")
            if hl then
                hl.Enabled = state
            end
        end
    end
end

return PlayerManager
