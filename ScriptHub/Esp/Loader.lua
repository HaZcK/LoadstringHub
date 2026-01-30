--[[
    UNIVERSAL LOADER
    Tugas: Manggil GUI dari GitHub & Connect ke PlayerManager
--]]

-- 1. Load PlayerManager (Logika ESP)
-- (Kalau PlayerManager-mu sudah di GitHub, pakai loadstring juga)
local PlayerManager = loadstring(game:HttpGet("URL_PLAYER_MANAGER_KAMU_DI_SINI"))()

-- 2. Load GUI dari GitHub kamu
local ESP_Gui_Script = loadstring(game:HttpGet("https://raw.githubusercontent.com/HaZcK/LoadstringHub/refs/heads/main/ScriptHub/Esp/Gui.lua", true))()

-- 3. Jalankan pemindaian player real-time
PlayerManager:Start()

-- 4. Menghubungkan Tombol di GUI ke Fungsi Manager
-- Kita asumsikan di dalam Gui.lua kamu ada tombol bernama 'ToggleBtn'
-- Kita pakai pcall supaya kalau tombolnya nggak ketemu, script nggak mati total.

local success, err = pcall(function()
    -- Cek apakah GUI mengembalikan objek/table
    local MainFrame = ESP_Gui_Script.MainFrame -- Sesuaikan dengan nama Frame di Gui.lua kamu
    local ToggleBtn = MainFrame:FindFirstChild("ToggleESP") -- Misal nama tombolnya 'ToggleESP'

    if ToggleBtn then
        ToggleBtn.MouseButton1Click:Connect(function()
            -- Switch status (On/Off)
            local newState = not PlayerManager.Enabled
            PlayerManager:SetState(newState)
            
            -- Feedback visual biar makin keren (Natural Human Touch)
            if newState then
                ToggleBtn.Text = "ESP: ON"
                ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 0) -- Ijo kalau nyala
            else
                ToggleBtn.Text = "ESP: OFF"
                ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih kalau mati
            end
        end)
    end
end)

if not success then
    warn("[ERROR] Gagal menyambungkan tombol GUI: " .. tostring(err))
end

print("[SYSTEM] Semua sistem berhasil dimuat dan terhubung!")

