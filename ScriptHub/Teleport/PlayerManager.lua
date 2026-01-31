-- playermanager.lua
-- LocalScript: populates the TeleportBaseGui body with a searchable list of players and models,
-- keeps it updated, and teleports the local player to a selected target on click.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local REFRESH_INTERVAL = 3           -- seconds (periodic full refresh)
local ENTRY_HEIGHT = 28
local ENTRY_PADDING = 6

-- Utility: wait for base GUI created by base.lua
local function getBaseBody()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("TeleportBaseGui")
    if not screenGui then return nil end
    local main = screenGui:FindFirstChild("Main")
    if not main then return nil end
    local body = main:FindFirstChild("Body")
    return body
end

-- Build UI inside the Body frame
local body = getBaseBody()
if not body then
    warn("TeleportBaseGui.Body not found. Make sure base.lua ran first and TeleportBaseGui exists in PlayerGui.")
    return
end

-- Avoid duplicate manager
local existingManager = body:FindFirstChild("PlayerManager")
if existingManager then
    existingManager:Destroy()
end

local manager = Instance.new("Frame")
manager.Name = "PlayerManager"
manager.Size = UDim2.new(1, 0, 1, 0)
manager.BackgroundTransparency = 1
manager.Parent = body

-- Search bar container
local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchFrame"
searchFrame.Size = UDim2.new(1, 0, 0, 34)
searchFrame.Position = UDim2.new(0, 0, 0, 0)
searchFrame.BackgroundTransparency = 1
searchFrame.Parent = manager

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.PlaceholderText = "Search players or models..."
searchBox.Size = UDim2.new(1, -92, 1, 0)
searchBox.Position = UDim2.new(0, 8, 0, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
searchBox.TextColor3 = Color3.fromRGB(230, 230, 230)
searchBox.Text = ""
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
searchBox.PlaceholderColor3 = Color3.fromRGB(160,160,160)
searchBox.Font = Enum.Font.SourceSans
searchBox.Parent = searchFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = searchBox

local searchBtn = Instance.new("TextButton")
searchBtn.Name = "SearchBtn"
searchBtn.Size = UDim2.new(0, 40, 1, 0)
searchBtn.Position = UDim2.new(1, -80, 0, 0)
searchBtn.Text = "🔎"
searchBtn.Font = Enum.Font.SourceSansBold
searchBtn.TextSize = 18
searchBtn.TextColor3 = Color3.fromRGB(255,255,255)
searchBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBtn.Parent = searchFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Name = "RefreshBtn"
refreshBtn.Size = UDim2.new(0, 40, 1, 0)
refreshBtn.Position = UDim2.new(1, -40, 0, 0)
refreshBtn.Text = "⟳"
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.TextSize = 18
refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
refreshBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
refreshBtn.Parent = searchFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = searchBtn
local btnCorner2 = btnCorner:Clone()
btnCorner2.Parent = refreshBtn

-- Scrolling frame for entries
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "PlayerList"
listFrame.Position = UDim2.new(0, 0, 0, 40)
listFrame.Size = UDim2.new(1, 0, 1, -40)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 6
listFrame.Parent = manager

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, ENTRY_PADDING)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = listFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 4)
uiPadding.PaddingBottom = UDim.new(0, 4)
uiPadding.PaddingLeft = UDim.new(0, 6)
uiPadding.PaddingRight = UDim.new(0, 6)
uiPadding.Parent = listFrame

-- Table to store current entries and mapping to instances
local entries = {}

-- Helper: find eligible models in Workspace
local function findEligibleModels()
    local results = {}
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") then
            -- skip player characters (they are listed separately)
            local isPlayerChar = false
            local owner = Players:GetPlayerFromCharacter(obj)
            if owner then
                isPlayerChar = true
            end
            if not isPlayerChar then
                -- consider model if it has a PrimaryPart or HumanoidRootPart
                if obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") then
                    table.insert(results, obj)
                end
            end
        end
    end
    return results
end

-- Teleport: move local player's character to targetCFrame
local teleportDebounce = false
local function teleportToCFrame(targetCFrame)
    if teleportDebounce then return end
    teleportDebounce = true
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not character then
        teleportDebounce = false
        return
    end

    -- Prefer :PivotTo if available
    local success, err = pcall(function()
        if character:FindFirstChild("HumanoidRootPart") then
            character:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
        elseif character.PrimaryPart then
            character:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
        else
            -- fallback: set HumanoidRootPart position if found later
            local hrp = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
            if hrp then
                hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
            end
        end
    end)
    if not success then
        warn("Teleport failed: "..tostring(err))
    end

    -- small cooldown to avoid accidental multiple teleports
    delay(0.4, function() teleportDebounce = false end)
end

-- Create an entry button for a target (player or model)
local function createEntry(displayName, targetInstance, kind)
    local btn = Instance.new("TextButton")
    btn.Name = "Entry_" .. tostring(math.random(1,1000000))
    btn.Size = UDim2.new(1, 0, 0, ENTRY_HEIGHT)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Text = displayName
    btn.AutoButtonColor = true
    btn.Parent = listFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    -- small label for kind (Player/Model)
    local kindLabel = Instance.new("TextLabel")
    kindLabel.Name = "Kind"
    kindLabel.Size = UDim2.new(0, 70, 1, 0)
    kindLabel.Position = UDim2.new(1, -74, 0, 0)
    kindLabel.BackgroundTransparency = 1
    kindLabel.Text = kind
    kindLabel.TextColor3 = Color3.fromRGB(160,160,160)
    kindLabel.TextSize = 14
    kindLabel.Font = Enum.Font.SourceSansItalic
    kindLabel.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- resolve target's teleport CFrame
        if not targetInstance or not targetInstance.Parent then
            -- target likely removed
            warn("Target no longer exists.")
            return
        end

        local targetCFrame = nil

        if kind == "Player" then
            local pl = targetInstance
            local char = pl.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                if hrp then
                    targetCFrame = hrp.CFrame
                end
            end
        else -- Model
            local model = targetInstance
            local p = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
            if p then
                targetCFrame = p.CFrame
            end
        end

        if targetCFrame then
            teleportToCFrame(targetCFrame)
        else
            warn("Could not determine target position for "..tostring(displayName))
        end
    end)

    return btn
end

-- Clear and rebuild list according to search filter
local function rebuildList(filterText)
    -- clear
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    entries = {}

    filterText = (filterText or ""):lower()

    -- Add players
    local players = Players:GetPlayers()
    for _, pl in ipairs(players) do
        if pl ~= LocalPlayer then -- optional: skip self
            local display = pl.Name
            if pl.DisplayName and pl.DisplayName ~= "" then
                display = string.format("%s (%s)", pl.DisplayName, pl.Name)
            end
            if filterText == "" or tostring(display):lower():find(filterText, 1, true) then
                local entry = createEntry(display, pl, "Player")
                table.insert(entries, {instance = pl, kind = "Player", button = entry, label = display})
            end
        end
    end

    -- Add eligible models
    local models = findEligibleModels()
    for _, model in ipairs(models) do
        local name = model.Name
        if filterText == "" or tostring(name):lower():find(filterText, 1, true) then
            local entry = createEntry(name, model, "Model")
            table.insert(entries, {instance = model, kind = "Model", button = entry, label = name})
        end
    end

    -- Update canvas size
    local layoutOrderCount = #listFrame:GetChildren()
    local totalHeight = (#entries) * (ENTRY_HEIGHT + ENTRY_PADDING) + 8
    listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Hook search actions
searchBtn.MouseButton1Click:Connect(function()
    rebuildList(searchBox.Text)
end)
refreshBtn.MouseButton1Click:Connect(function()
    searchBox.Text = ""
    rebuildList("")
end)
searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        rebuildList(searchBox.Text)
    end
end)

-- Live updates: players and workspace models
Players.PlayerAdded:Connect(function()
    rebuildList(searchBox.Text)
end)
Players.PlayerRemoving:Connect(function()
    rebuildList(searchBox.Text)
end)
Workspace.ChildAdded:Connect(function(child)
    -- small filter: only rebuild for models
    if child:IsA("Model") then
        rebuildList(searchBox.Text)
    end
end)
Workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        rebuildList(searchBox.Text)
    end
end)

-- Periodic refresh in case something changed
spawn(function()
    while manager and manager.Parent do
        rebuildList(searchBox.Text)
        wait(REFRESH_INTERVAL)
    end
end)

-- Initial populate
rebuildList("")

-- Handy: expose a simple API for external scripts if needed
manager:SetAttribute("Version", 1)
manager.Parent = body

-- Done
print("PlayerManager initialized: shows players and workspace models. Click an entry to teleport to it.")
