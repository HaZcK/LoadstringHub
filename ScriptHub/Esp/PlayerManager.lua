-- [[ PLAYER MANAGER - TRACKING DATA ]] --
local PlayerManager = {}
local Players = game:GetService("Players")

PlayerManager.AllPlayers = {}

function PlayerManager:UpdateList()
    self.AllPlayers = Players:GetPlayers()
    return self.AllPlayers
end

-- Ambil data lengkap player buat ditampilin di GUI
function PlayerManager:GetPlayerData(player)
    return {
        Name = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        Instance = player
    }
end

return PlayerManager
