--[[
    ESP Interface Framework
    Built with a "Red-Alert" theme
    Custom orange outlines for that tactical look
--]]

local ESP_Gui = {}

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

function ESP_Gui:Init()
    -- Create the main container, protecting it from being easily seen in scripts
    local MainRoot = Instance.new("ScreenGui")
    MainRoot.Name = "Internal_Scanner_v1"
    MainRoot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui so it doesn't reset on death, 
    -- fallback to PlayerGui if we don't have permissions
    local success, err = pcall(function()
        MainRoot.Parent = CoreGui
    end)
    if not success then
        MainRoot.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main Container Frame
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Name = "MainContainer"
    MenuFrame.Size = UDim2.new(0, 220, 0, 300)
    MenuFrame.Position = UDim2.new(0.1, 0, 0.4, 0) -- Nice side position
    MenuFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Solid Dark Red
    MenuFrame.BorderSizePixel = 0
    MenuFrame.Active = true
    MenuFrame.Draggable = true -- Old school but handy
    MenuFrame.Parent = MainRoot

    -- The "Orange Outline" you asked for
    local Outline = Instance.new("UIStroke")
    Outline.Name = "MenuBorder"
    Outline.Color = Color3.fromRGB(255, 100, 0) -- Vibrant Orange
    Outline.Thickness = 2.5
    Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Outline.Parent = MenuFrame

    -- Rounding the edges just a bit
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MenuFrame

    -- Title Section
    local Header = Instance.new("TextLabel")
    Header.Name = "HeaderTitle"
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Lighter Red for Header
    Header.Text = "  ESP SCANNER"
    Header.TextColor3 = Color3.new(1, 1, 1)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Font = Enum.Font.SourceSansBold
    Header.TextSize = 18
    Header.Parent = MenuFrame

    -- Add a small orange separator under header
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 2)
    Divider.Position = UDim2.new(0, 0, 0, 35)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    Divider.BorderSizePixel = 0
    Divider.Parent = MenuFrame

    -- Body Content Container (Where buttons will go)
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "ItemsList"
    Content.Size = UDim2.new(1, -10, 1, -45)
    Content.Position = UDim2.new(0, 5, 0, 40)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 2
    Content.CanvasSize = UDim2.new(0, 0, 2, 0) -- Scrollable area
    Content.Parent = MenuFrame

    print("[SYSTEM] ESP GUI initialized successfully.")
    return MenuFrame
end

-- Let's boot it up
local myMenu = ESP_Gui:Init()

-- Simple toggle visibility (Standard human-style function)
local function toggleGui(state)
    myMenu.Visible = state
end

return ESP_Gui
