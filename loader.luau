-- ========================================
-- TWISTEDHOOK v7 - Mobile Friendly
-- Testing on Roblox Rivals
-- ========================================

if getgenv().TwistedhookLoaded then
    print("⚠ TWISTEDHOOK already loaded!")
    return
end

getgenv().TwistedhookLoaded = true
print("[DEBUG] Script starting...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("[ERROR] LocalPlayer not found!")
    return
end

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

print("[DEBUG] Basic setup complete")

-- Get PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("[ERROR] PlayerGui not found!")
    return
end

-- ==================== SIMPLE UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DebugUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Title.BorderSizePixel = 0
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Text = "TWISTEDHOOK v7"
Title.Parent = MainFrame

-- Draggable
local Dragging = false
local DragStart = nil
local StartPos = nil

Title.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and DragStart and StartPos then
        local delta = input.Position - DragStart
        MainFrame.Position = StartPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Status display
local StatusFrame = Instance.new("TextLabel")
StatusFrame.Size = UDim2.new(1, -10, 0, 80)
StatusFrame.Position = UDim2.new(0, 5, 0, 45)
StatusFrame.BackgroundTransparency = 1
StatusFrame.TextColor3 = Color3.new(1, 1, 1)
StatusFrame.TextSize = 12
StatusFrame.Font = Enum.Font.Gotham
StatusFrame.TextWrapped = true
StatusFrame.TextXAlignment = Enum.TextXAlignment.Left
StatusFrame.TextYAlignment = Enum.TextYAlignment.Top
StatusFrame.Parent = MainFrame

print("[DEBUG] UI Created")

-- ==================== FEATURE FLAGS ====================
local ESPEnabled = false
local SpeedEnabled = false
local ESPBoxes = {}
local OriginalSpeed = 16

-- ==================== ESP SYSTEM ====================
local function CreateESPBox(player, character)
    if not character then return end
    
    print("[ESP] Attempting to create box for " .. player.Name)
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") 
        or character:FindFirstChild("Torso")
        or character:FindFirstChildOfClass("Part")
    
    if not rootPart then
        print("[ESP] ERROR: No root part found for " .. player.Name)
        return
    end
    
    print("[ESP] Found root part: " .. rootPart.Name)
    
    -- Create billboard GUI
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.MaxDistance = math.huge
    billboard.Size = UDim2.new(4, 0, 5, 0)
    billboard.Parent = rootPart
    
    -- Main frame for ESP box
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.3  -- More transparent so it shows through
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
    frame.Parent = billboard
    
    -- Player name label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.3, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Text = player.Name
    label.Parent = frame
    
    ESPBoxes[player] = billboard
    print("[ESP] ✓ Box created for " .. player.Name)
end

local function UpdateESP()
    if not ESPEnabled then
        for player, box in pairs(ESPBoxes) do
            if box and box.Parent then
                pcall(function() box:Destroy() end)
            end
        end
        ESPBoxes = {}
        return
    end
    
    -- Add ESP to all players
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            if not ESPBoxes[player] then
                CreateESPBox(player, player.Character)
            end
        end
    end
end

-- Clean up ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        pcall(function() ESPBoxes[player]:Destroy() end)
        ESPBoxes[player] = nil
    end
end)

-- ==================== SPEED SYSTEM ====================
local function UpdateSpeed()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if SpeedEnabled then
        humanoid.WalkSpeed = OriginalSpeed * 1.5
    else
        humanoid.WalkSpeed = OriginalSpeed
    end
end

-- Track original speed when character loads
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.1)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        OriginalSpeed = humanoid.WalkSpeed
        print("[SPEED] Original speed set to: " .. OriginalSpeed)
    end
end)

-- Store original speed on first run
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        OriginalSpeed = humanoid.WalkSpeed
        print("[SPEED] Original speed: " .. OriginalSpeed)
    end
end

-- ==================== BUTTON CREATION ====================
local function CreateButton(yPosition, buttonName, featureName, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPosition)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Text = "[ OFF ] " .. buttonName
    Button.BorderSizePixel = 0
    Button.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    local State = false
    
    local function UpdateButton()
        if State then
            Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            Button.Text = "[ ON ] " .. buttonName
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Button.Text = "[ OFF ] " .. buttonName
            Button.TextColor3 = Color3.new(1, 1, 1)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        State = not State
        UpdateButton()
        callback(State)
        print("[TWISTEDHOOK] " .. featureName .. " = " .. (State and "ON" or "OFF"))
    end)
    
    Button.Activated:Connect(function()
        State = not State
        UpdateButton()
        callback(State)
        print("[TWISTEDHOOK] " .. featureName .. " = " .. (State and "ON" or "OFF"))
    end)
    
    Button.MouseEnter:Connect(function()
        if not State then
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
    end)
    
    Button.MouseLeave:Connect(function()
        UpdateButton()
    end)
    
    return Button, function() return State end
end

-- Create buttons
local ESPButton, getESPState = CreateButton(140, "ESP", "ESP", function(state)
    ESPEnabled = state
    UpdateESP()
end)

local SpeedButton, getSpeedState = CreateButton(185, "SPEED", "Speed Boost", function(state)
    SpeedEnabled = state
    UpdateSpeed()
end)

print("[DEBUG] Buttons created")

-- ==================== MAIN LOOP ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        UpdateESP()
        UpdateSpeed()
        
        -- Update status display
        local playerCount = #Players:GetPlayers()
        StatusFrame.Text = "Players: " .. playerCount .. "\nESP: " .. (ESPEnabled and "✓ ON" or "✗ OFF") .. "\nSpeed: " .. (SpeedEnabled and "✓ ON" or "✗ OFF") .. "\nBoxes: " .. tostring(#ESPBoxes)
    end)
end)

print("[DEBUG] Loop connected")
print("✓ Script loaded!")
print("✓ TAP buttons to toggle features")
print("✓ DRAG title to move menu")
