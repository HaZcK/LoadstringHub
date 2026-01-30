-- [[ FINAL LOADER ]] --
local PlayerManager = loadstring(game:HttpGet("LINK_PLAYER_MANAGER"))()
local GuiModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HaZcK/LoadstringHub/refs/heads/main/ScriptHub/Esp/Gui.lua"))()
local FuncModule = loadstring(game:HttpGet("LINK_FUNCTION_LUA"))()

local sg, mainFrame, playerList, selAllBtn, closeBtn = GuiModule:Create()
sg.Parent = game:GetService("CoreGui") -- Biar aman

-- Jalankan List Pertama Kali
FuncModule:RefreshPlayerList(playerList, PlayerManager)

-- Tombol Select All
selAllBtn.MouseButton1Click:Connect(function()
    FuncModule.SelectAllActive = not FuncModule.SelectAllActive
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            -- Pasang highlight ke semua kalau belum ada
            if FuncModule.SelectAllActive and not FuncModule.Highlights[p.UserId] then
                FuncModule:ToggleHighlight(p)
            elseif not FuncModule.SelectAllActive and FuncModule.Highlights[p.UserId] then
                FuncModule:ToggleHighlight(p)
            end
        end
    end
    selAllBtn.Text = FuncModule.SelectAllActive and "DESELECT ALL" or "SELECT ALL"
end)

-- Tombol Close (Hapus Semua)
closeBtn.MouseButton1Click:Connect(function()
    -- Bersihin semua highlight sebelum pergi
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Target_HL") then
            p.Character.Target_HL:Destroy()
        end
    end
    sg:Destroy()
    print("ESP Closed Permanently.")
end)

-- Auto Update kalau ada player join/leave
game.Players.PlayerAdded:Connect(function()
    wait(1)
    FuncModule:RefreshPlayerList(playerList, PlayerManager)
end)

game.Players.PlayerRemoving:Connect(function()
    FuncModule:RefreshPlayerList(playerList, PlayerManager)
end)
