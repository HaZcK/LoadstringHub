-- [[ PLAYERMANAGER.LUA - THE AUTO-UPDATER ]] --
local PlayerManager = {}
local Players = game:GetService("Players")

-- Kita butuh referensi ke Fungsi untuk memanggil Refresh saat ada kejadian
PlayerManager.ListFrame = nil
PlayerManager.FuncModule = nil

function PlayerManager:Init(listFrame, funcModule)
    self.ListFrame = listFrame
    self.FuncModule = funcModule

    -- 1. Pantau Player baru masuk
    Players.PlayerAdded:Connect(function(player)
        -- Kasih jeda dikit biar datanya siap
        task.wait(1)
        print("[!] New Player Detected: " .. player.Name)
        self.FuncModule:RefreshPlayerList(self.ListFrame, self)
    end)

    -- 2. Pantau Player keluar
    Players.PlayerRemoving:Connect(function(player)
        print("[!] Player Left: " .. player.Name)
        -- Refresh list karena ada yang berkurang
        self.FuncModule:RefreshPlayerList(self.ListFrame, self)
    end)

    -- 3. Load pertama kali untuk player yang sudah ada di server
    self.FuncModule:RefreshPlayerList(self.ListFrame, self)
end

-- Fungsi bantu untuk ambil data (dipakai oleh Function.lua)
function PlayerManager:UpdateList()
    return Players:GetPlayers()
end

function PlayerManager:GetPlayerData(player)
    return {
        Name = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        Instance = player
    }
end

return PlayerManager
