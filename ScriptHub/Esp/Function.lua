-- [[ FUNCTION.LUA - THE BRAIN ]] --
local Func = {}
local Players = game:GetService("Players")

Func.Highlights = {} -- Tabel buat nyimpen siapa aja yang lagi di-highlight
Func.SelectAllActive = false

-- Fungsi buat pasang/copot Highlight (Toggle)
function Func:ToggleHighlight(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local char = targetPlayer.Character
    local existing = char:FindFirstChild("Target_HL")
    
    if existing then
        existing:Destroy()
        Func.Highlights[targetPlayer.UserId] = nil
    else
        local hl = Instance.new("Highlight")
        hl.Name = "Target_HL"
        hl.FillColor = Color3.new(1, 0, 0)
        hl.OutlineColor = Color3.new(1, 0.5, 0)
        hl.FillTransparency = 0.5
        hl.Parent = char
        Func.Highlights[targetPlayer.UserId] = true
    end
end

-- Fungsi buat update isi list di GUI
function Func:RefreshPlayerList(listFrame, manager)
    -- Bersihin list lama
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    -- Tambahin player yang ada
    for _, p in pairs(manager:UpdateList()) do
        if p == Players.LocalPlayer then continue end
        
        local pData = manager:GetPlayerData(p)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Text = string.format("%s (@%s)\nID: %d", pData.DisplayName, pData.Name, pData.UserId)
        btn.TextSize = 12
        btn.Parent = listFrame
        
        -- Klik satu player
        btn.MouseButton1Click:Connect(function()
            Func:ToggleHighlight(p)
            btn.BackgroundColor3 = Func.Highlights[p.UserId] and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(40, 0, 0)
        end)
    end
end

return Func
