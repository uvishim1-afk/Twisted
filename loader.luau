-- ========================================
-- TWISTEDHOOK v4.1 - Fixed Features
-- ========================================

if getgenv().TwistedhookLoaded then
    print("⚠ TWISTEDHOOK already loaded!")
    return
end

getgenv().TwistedhookLoaded = true
print("[TWISTEDHOOK] Script starting...")

-- Get services safely
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("[ERROR] LocalPlayer not found!")
    return
end

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Config
local Config = {
    ESP = { Enabled = false },
    Aimbot = { Enabled = false, FOV = 300 },
    Speed = { Enabled = false, BaseSpeed = 16 },
    Skins = { Enabled = false },
}

-- Get PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("[ERROR] PlayerGui not found!")
    return
end

-- ==================== CREATE UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TwistedhookUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 400)
MainFrame.Position = UDim2.new(0.5, -140, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TitleLabel.BorderSizePixel = 0
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ TWISTEDHOOK v4.1"
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel

-- ScrollFrame for buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.Parent = ScrollFrame

print("[TWISTEDHOOK] UI Created")

-- ==================== BUTTON CREATOR ====================
local ButtonStates = {}

local function CreateToggleButton(name, key)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 35)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = ScrollFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = "[ OFF ] " .. name
    Button.BorderSizePixel = 0
    Button.Parent = ButtonContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    ButtonStates[key] = false
    
    local function UpdateButton()
        if ButtonStates[key] then
            Button.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
            Button.Text = "[ ON ] " .. name
            Button.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Button.Text = "[ OFF ] " .. name
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        ButtonStates[key] = not ButtonStates[key]
        UpdateButton()
        print("[TWISTEDHOOK] " .. name .. " = " .. (ButtonStates[key] and "ON" or "OFF"))
    end)
    
    Button.MouseEnter:Connect(function()
        if not ButtonStates[key] then
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
    end)
    
    Button.MouseLeave:Connect(function()
        UpdateButton()
    end)
end

-- Create buttons
CreateToggleButton("ESP", "esp")
CreateToggleButton("Aimbot", "aimbot")
CreateToggleButton("FOV Circle", "fov")
CreateToggleButton("Speed Boost", "speed")
CreateToggleButton("Skin Changer", "skins")

print("[TWISTEDHOOK] Buttons created")

-- ==================== DRAGGABLE MENU ====================
local Dragging = false
local DragStart = nil
local StartPos = nil

TitleLabel.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Mouse.Position
        StartPos = MainFrame.Position
    end
end)

TitleLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

Mouse.Move:Connect(function()
    if Dragging and DragStart and StartPos then
        local Delta = Mouse.Position - DragStart
        MainFrame.Position = StartPos + UDim2.new(0, Delta.X, 0, Delta.Y)
    end
end)

-- ==================== TOGGLE MENU KEY ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        MainFrame.Visible = not MainFrame.Visible
        print("[TWISTEDHOOK] Menu toggled: " .. (MainFrame.Visible and "SHOWN" or "HIDDEN"))
    end
end)

print("[TWISTEDHOOK] Menu controls bound")

-- ==================== ESP IMPLEMENTATION ====================
local ESPTable = {}

local function ESP_Update()
    -- Clear ESP if disabled
    if not ButtonStates["esp"] then
        for player, obj in pairs(ESPTable) do
            if obj and obj.Parent then
                pcall(function() obj:Destroy() end)
            end
            ESPTable[player] = nil
        end
        return
    end
    
    -- Add ESP to new players
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and not ESPTable[player] then
                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = root
                billboard.MaxDistance = math.huge
                billboard.Size = UDim2.new(3, 0, 4, 0)
                billboard.Parent = root
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Parent = billboard
                
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(200, 100, 255)
                stroke.Thickness = 2
                stroke.Parent = frame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0.3, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.Text = player.Name
                label.Parent = frame
                
                ESPTable[player] = billboard
                print("[TWISTEDHOOK] ESP added for " .. player.Name)
            end
        end
    end
end

-- Remove ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    if ESPTable[player] then
        pcall(function() ESPTable[player]:Destroy() end)
        ESPTable[player] = nil
    end
end)

-- ==================== SPEED BOOST ====================
local OriginalSpeed = 16

local function Speed_Update()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if ButtonStates["speed"] then
        humanoid.WalkSpeed = OriginalSpeed * 2
        print("[TWISTEDHOOK] Speed set to " .. (OriginalSpeed * 2))
    else
        humanoid.WalkSpeed = OriginalSpeed
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.2)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        OriginalSpeed = humanoid.WalkSpeed
        print("[TWISTEDHOOK] Original speed: " .. OriginalSpeed)
    end
end)

-- ==================== SKIN CHANGER ====================
local function Skins_Update()
    if not ButtonStates["skins"] or not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(100, 0, 200)
            part.Material = Enum.Material.Neon
        end
    end
end

-- ==================== AIMBOT ====================
local function FindClosestEnemy()
    if not LocalPlayer.Character then return nil end
    
    local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    
    local closest = nil
    local closestDist = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if root and humanoid and humanoid.Health > 0 then
                local dist = (root.Position - myPos.Position).Magnitude
                if dist < closestDist then
                    closest = root
                    closestDist = dist
                end
            end
        end
    end
    
    return closest
end

local function Aimbot_Update()
    if not ButtonStates["aimbot"] or not LocalPlayer.Character then return end
    
    local target = FindClosestEnemy()
    if target then
        local newCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.1)
    end
end

-- ==================== FOV CIRCLE ====================
local FOVGui = ScreenGui:FindFirstChild("FOVCanvas")
if not FOVGui then
    FOVGui = Instance.new("Frame")
    FOVGui.Name = "FOVCanvas"
    FOVGui.Size = UDim2.new(1, 0, 1, 0)
    FOVGui.BackgroundTransparency = 1
    FOVGui.BorderSizePixel = 0
    FOVGui.ZIndex = 0
    FOVGui.Parent = ScreenGui
end

local function FOV_Update()
    FOVGui:ClearAllChildren()
    
    if not ButtonStates["fov"] or not ButtonStates["aimbot"] then
        return
    end
    
    local centerX = Mouse.X
    local centerY = Mouse.Y
    local radius = Config.Aimbot.FOV
    
    for i = 1, 30 do
        local angle1 = (i - 1) * (2 * math.pi / 30)
        local angle2 = i * (2 * math.pi / 30)
        
        local x1 = math.cos(angle1) * radius
        local y1 = math.sin(angle1) * radius
        local x2 = math.cos(angle2) * radius
        local y2 = math.sin(angle2) * radius
        
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        line.BorderSizePixel = 0
        line.ZIndex = 0
        line.Parent = FOVGui
        
        local length = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
        local angle = math.atan2(y2 - y1, x2 - x1)
        
        line.Size = UDim2.new(0, length, 0, 1)
        line.Position = UDim2.new(0, centerX + x1, 0, centerY + y1)
        line.Rotation = math.deg(angle)
    end
end

print("[TWISTEDHOOK] All systems initialized")

-- ==================== MAIN LOOP ====================
local UpdateCounter = 0

RunService.Heartbeat:Connect(function()
    UpdateCounter = UpdateCounter + 1
    
    pcall(function()
        -- Update every frame
        Speed_Update()
        Aimbot_Update()
        Skins_Update()
        
        -- Update every other frame
        if UpdateCounter % 2 == 0 then
            ESP_Update()
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        FOV_Update()
    end)
end)

print("✅ TWISTEDHOOK v4.1 LOADED!")
print("✅ Press 'P' to toggle menu")
print("✅ All features working!")
