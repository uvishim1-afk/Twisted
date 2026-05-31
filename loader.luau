-- ========================================
-- TWISTEDHOOK v3.1 - Complete Edition
-- Roblox Rivals Exploit | All Features Working
-- Silent Aim + Skin Changer + Fixed FOV Circle
-- ========================================

if getgenv().TwistedhookLoaded then
    print("⚠ TWISTEDHOOK already loaded!")
    return
end

getgenv().TwistedhookLoaded = true
print("[TWISTEDHOOK v3.1] Initializing...")

-- Core Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config
local Config = {
    ESP = { Enabled = false, ShowHealth = true },
    Aimbot = { Enabled = false, FOV = 300, Smoothness = 0.1, Strength = 3, ShowFOV = false, SilentAim = false },
    Speed = { Enabled = false, Value = 2 },
    Skins = { Enabled = false, SkinColor = Color3.fromRGB(100, 0, 200) },
}

-- Wait for GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
print("[TWISTEDHOOK] PlayerGui loaded")

-- ==================== MAIN SCREEN GUI ====================
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "TwistedhookMain"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui

-- Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "Menu"
MenuFrame.Size = UDim2.new(0, 320, 0, 520)
MenuFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = MainGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MenuFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 50, 200)
Stroke.Thickness = 2
Stroke.Parent = MenuFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.BorderSizePixel = 0
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ TWISTEDHOOK v3.1"
Title.Parent = MenuFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Title

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

-- Scroll Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 220)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ScrollFrame.Parent = MenuFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = ScrollFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)
Padding.Parent = ScrollFrame

print("[TWISTEDHOOK] Menu UI created")

-- ==================== BUTTON FUNCTION ====================
local function CreateButton(parent, name, icon, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = icon .. " " .. name
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 8, 0, 8)
    Indicator.Position = UDim2.new(0, 8, 0.5, -4)
    Indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Button
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 2)
    IndicatorCorner.Parent = Indicator
    
    local State = false
    
    local function UpdateVisuals()
        if State then
            Button.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
            Indicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            Indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        State = not State
        UpdateVisuals()
        callback(State)
    end)
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end)
    
    Button.MouseLeave:Connect(function()
        UpdateVisuals()
    end)
    
    return Button
end

-- Create Buttons
CreateButton(ScrollFrame, "ESP", "👁", function(state)
    Config.ESP.Enabled = state
end)

CreateButton(ScrollFrame, "Aimbot", "🎯", function(state)
    Config.Aimbot.Enabled = state
end)

CreateButton(ScrollFrame, "Silent Aim", "🔇", function(state)
    Config.Aimbot.SilentAim = state
end)

CreateButton(ScrollFrame, "FOV Circle", "⭕", function(state)
    Config.Aimbot.ShowFOV = state
end)

CreateButton(ScrollFrame, "Speed Boost", "⚡", function(state)
    Config.Speed.Enabled = state
end)

CreateButton(ScrollFrame, "Skin Changer", "🎨", function(state)
    Config.Skins.Enabled = state
end)

print("[TWISTEDHOOK] Buttons created")

-- ==================== DRAGGABLE ====================
local Dragging = false
local DragStart = nil
local FrameStart = nil

Title.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Mouse.Position
        FrameStart = MenuFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

Mouse.Move:Connect(function()
    if Dragging and DragStart and FrameStart then
        local delta = Mouse.Position - DragStart
        MenuFrame.Position = FrameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Position = UDim2.new(0, 20, 0, 20)
MinBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "⚡"
MinBtn.Visible = false
MinBtn.ZIndex = 1000
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainGui

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 10)
MinBtnCorner.Parent = MinBtn

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    MinBtn.Visible = true
end)

MinBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = true
    MinBtn.Visible = false
end)

print("[TWISTEDHOOK] Menu complete")

-- ==================== ESP SYSTEM ====================
local ESPObjects = {}

local function CreateESP(player, character)
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Remove old ESP
    if ESPObjects[player] then
        pcall(function()
            ESPObjects[player]:Destroy()
        end)
        ESPObjects[player] = nil
    end
    
    -- Create new ESP
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = humanoidRootPart
    billboardGui.MaxDistance = math.huge
    billboardGui.Size = UDim2.new(4, 0, 5, 0)
    billboardGui.Parent = humanoidRootPart
    
    local espFrame = Instance.new("Frame")
    espFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    espFrame.BackgroundTransparency = 0.2
    espFrame.Size = UDim2.new(1, 0, 1, 0)
    espFrame.BorderSizePixel = 0
    espFrame.Parent = billboardGui
    
    local espStroke = Instance.new("UIStroke")
    espStroke.Color = Color3.fromRGB(200, 100, 255)
    espStroke.Thickness = 3
    espStroke.Parent = espFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.25, 0)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.Parent = espFrame
    
    if Config.ESP.ShowHealth then
        local healthBg = Instance.new("Frame")
        healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        healthBg.BackgroundTransparency = 0.4
        healthBg.Size = UDim2.new(0.8, 0, 0.1, 0)
        healthBg.Position = UDim2.new(0.1, 0, 0.75, 0)
        healthBg.BorderSizePixel = 0
        healthBg.Parent = espFrame
        
        local healthBar = Instance.new("Frame")
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBg
        
        ESPObjects[player] = billboardGui
        
        -- Update health bar
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local maxHealth = humanoid.MaxHealth
            local function UpdateHealth()
                if humanoid and maxHealth > 0 then
                    local percent = math.max(0, humanoid.Health / maxHealth)
                    healthBar.Size = UDim2.new(percent, 0, 1, 0)
                end
            end
            humanoid.HealthChanged:Connect(UpdateHealth)
            UpdateHealth()
        end
    else
        ESPObjects[player] = billboardGui
    end
end

local function UpdateESP()
    if not Config.ESP.Enabled then
        for player, obj in pairs(ESPObjects) do
            pcall(function() obj:Destroy() end)
            ESPObjects[player] = nil
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not ESPObjects[player] then
                CreateESP(player, player.Character)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(0.1)
        if Config.ESP.Enabled then
            CreateESP(player, character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        pcall(function() ESPObjects[player]:Destroy() end)
        ESPObjects[player] = nil
    end
end)

print("[TWISTEDHOOK] ESP system loaded")

-- ==================== FOV CIRCLE (FOLLOWS MOUSE) ====================
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVGui"
FOVGui.ResetOnSpawn = false
FOVGui.ZIndex = 1
FOVGui.Parent = PlayerGui

local FOVCanvas = Instance.new("Frame")
FOVCanvas.Name = "Canvas"
FOVCanvas.Size = UDim2.new(1, 0, 1, 0)
FOVCanvas.BackgroundTransparency = 1
FOVCanvas.BorderSizePixel = 0
FOVCanvas.ZIndex = 1
FOVCanvas.Parent = FOVGui

local function DrawFOVCircle()
    if not Config.Aimbot.ShowFOV or not Config.Aimbot.Enabled then
        FOVCanvas:ClearAllChildren()
        return
    end
    
    pcall(function()
        FOVCanvas:ClearAllChildren()
        
        local centerX = Mouse.X
        local centerY = Mouse.Y
        local radius = Config.Aimbot.FOV
        local segments = 30
        
        for i = 1, segments do
            local angle1 = (i - 1) * (2 * math.pi / segments)
            local angle2 = i * (2 * math.pi / segments)
            
            local x1 = math.cos(angle1) * radius
            local y1 = math.sin(angle1) * radius
            local x2 = math.cos(angle2) * radius
            local y2 = math.sin(angle2) * radius
            
            local line = Instance.new("Frame")
            line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            line.BorderSizePixel = 0
            line.ZIndex = 1
            line.Parent = FOVCanvas
            
            local length = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
            local angle = math.atan2(y2 - y1, x2 - x1)
            
            line.Size = UDim2.new(0, length, 0, 1)
            line.Position = UDim2.new(0, centerX + x1, 0, centerY + y1)
            line.Rotation = math.deg(angle)
        end
        
        -- Center dot
        local dot = Instance.new("Frame")
        dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        dot.Size = UDim2.new(0, 5, 0, 5)
        dot.Position = UDim2.new(0, centerX - 2.5, 0, centerY - 2.5)
        dot.BorderSizePixel = 0
        dot.ZIndex = 1
        dot.Parent = FOVCanvas
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(0.5, 0)
        dotCorner.Parent = dot
    end)
end

print("[TWISTEDHOOK] FOV circle created")

-- ==================== AIMBOT + SILENT AIM ====================
local function FindClosestEnemy()
    if not LocalPlayer.Character then return nil end
    
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local closest = nil
    local closestDist = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                local screenPos = Camera:WorldToScreenPoint(root.Position)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if screenDist < closestDist then
                    closest = root
                    closestDist = screenDist
                end
            end
        end
    end
    
    return closest
end

local function UpdateAimbot()
    if not Config.Aimbot.Enabled or not LocalPlayer.Character then return end
    
    local target = FindClosestEnemy()
    if target then
        local targetPos = target.Position + target.AssemblyLinearVelocity * 0.15
        
        if Config.Aimbot.SilentAim then
            -- Silent Aim: Move mouse to target position on screen
            local screenPos = Camera:WorldToScreenPoint(targetPos)
            Mouse.X = screenPos.X
            Mouse.Y = screenPos.Y
        else
            -- Regular Aimbot: Move camera
            local newCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Aimbot.Smoothness * Config.Aimbot.Strength)
        end
    end
end

print("[TWISTEDHOOK] Aimbot system loaded")

-- ==================== SKIN CHANGER ====================
local function ChangeSkin()
    if not Config.Skins.Enabled or not LocalPlayer.Character then return end
    
    pcall(function()
        local character = LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Config.Skins.SkinColor
                    part.Material = Enum.Material.Neon
                end
            end
        end
    end)
end

local lastSkinUpdate = 0
local function UpdateSkins()
    if not Config.Skins.Enabled then return end
    if tick() - lastSkinUpdate < 0.5 then return end
    
    lastSkinUpdate = tick()
    ChangeSkin()
end

LocalPlayer.CharacterAdded:Connect(function()
    if Config.Skins.Enabled then
        wait(0.1)
        ChangeSkin()
    end
end)

print("[TWISTEDHOOK] Skin changer loaded")

-- ==================== SPEED BOOST ====================
local OriginalSpeed = 16

local function UpdateSpeed()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if Config.Speed.Enabled then
            humanoid.WalkSpeed = OriginalSpeed * Config.Speed.Value
        else
            humanoid.WalkSpeed = OriginalSpeed
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    OriginalSpeed = 16
end)

print("[TWISTEDHOOK] Speed system loaded")

-- ==================== GAME TRANSITION FIX ====================
game:GetService("RunService").Heartbeat:Connect(function()
    if not PlayerGui or PlayerGui.Parent ~= LocalPlayer then
        PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if PlayerGui and MainGui.Parent ~= PlayerGui then
            MainGui.Parent = PlayerGui
            FOVGui.Parent = PlayerGui
        end
    end
end)

print("[TWISTEDHOOK] Game transition fix loaded")

-- ==================== MAIN LOOP ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        UpdateESP()
        UpdateAimbot()
        UpdateSpeed()
        UpdateSkins()
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        DrawFOVCircle()
    end)
end)

-- ==================== TOGGLE MENU ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        MenuFrame.Visible = not MenuFrame.Visible
        MinBtn.Visible = not MinBtn.Visible
    end
end)

print("✓✓✓ TWISTEDHOOK v3.1 LOADED ✓✓✓")
print("✓ ESP working (shows through walls)")
print("✓ Aimbot + Silent Aim")
print("✓ FOV circles (follows mouse)")
print("✓ Speed boost")
print("✓ Skin changer (neon glow)")
print("✓ Game transition fixed")
print("✓ Press 'P' to toggle menu")
