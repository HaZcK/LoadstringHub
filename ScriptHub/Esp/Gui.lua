-- [[ GUI.LUA - THE INTERFACE ]] --
local Gui = {}

function Gui:Create()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Scanner_UI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame Utama (Merah/Orange)
    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    frame.Active = true
    frame.Draggable = true -- Biar bisa digeser
    frame.Parent = sg
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 120, 0)
    stroke.Thickness = 3
    stroke.Parent = frame
    
    -- Tombol Close (Pojok Kanan Atas)
    local close = Instance.new("TextButton")
    close.Name = "CloseBtn"
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.Text = "X"
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = frame

    -- Tombol Select All
    local selAll = Instance.new("TextButton")
    selAll.Name = "SelectAll"
    selAll.Size = UDim2.new(0.9, 0, 0, 30)
    selAll.Position = UDim2.new(0.05, 0, 0, 40)
    selAll.Text = "SELECT ALL"
    selAll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    selAll.TextColor3 = Color3.fromRGB(255, 120, 0)
    selAll.Parent = frame

    -- Daftar Player (Scrolling Frame)
    local list = Instance.new("ScrollingFrame")
    list.Name = "PlayerList"
    list.Size = UDim2.new(0.9, 0, 0.7, 0)
    list.Position = UDim2.new(0.05, 0, 0.22, 0)
    list.BackgroundTransparency = 1
    list.CanvasSize = UDim2.new(0, 0, 5, 0)
    list.ScrollBarThickness = 3
    list.Parent = frame

    -- UI List Layout biar otomatis rapi
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = list

    return sg, frame, list, selAll, close
end

return Gui
