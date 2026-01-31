-- 1. Membuat GUI Utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DaftarPemainGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- 2. Membuat Frame (Kotak Utama)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.5, -100, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- 3. Membuat Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "PLAYER LIST"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

-- 4. Membuat ScrollingFrame (Biar kalau rame bisa di-scroll)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan otomatis bertambah
scrollFrame.Parent = frame

-- 5. Menambahkan UI List Layout (Agar nama otomatis tersusun rapi)
local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi untuk memperbarui daftar pemain
local function updateList()
    -- Hapus daftar lama
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Ambil semua pemain dan masukkan ke list
    for _, player in pairs(game.Players:GetPlayers()) do
        local playerLabel = Instance.new("TextLabel")
        playerLabel.Size = UDim2.new(1, 0, 0, 25)
        playerLabel.Text = player.Name
        playerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        playerLabel.BackgroundTransparency = 0.8
        playerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        playerLabel.Parent = scrollFrame
    end
    
    -- Sesuaikan ukuran scroll otomatis
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Update list saat ada yang masuk atau keluar
game.Players.PlayerAdded:Connect(updateList)
game.Players.PlayerRemoving:Connect(updateList)

-- Jalankan fungsi pertama kali
updateList()

