-- ========================================
-- TWISTEDHOOK v6 - ESP + SPEED
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
MainFrame.Size = UDim2.new(0, 300, 0, 260)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -130)
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
Title.Text = "TWISTEDHOOK v6"
Title.Parent = MainFrame

-- Debug info frame
local InfoFrame = Instance.new("TextLabel")
InfoFrame.Size = UDim2.new(1, -10, 1, -50)
InfoFrame.Position = UDim2.new(0, 5, 0, 45)
InfoFrame.BackgroundTransparency = 1
InfoFrame.TextColor3 = Color3.new(1, 1, 1)
InfoFrame.TextSize = 11
InfoFrame.Font = Enum.Font.Gotham
InfoFrame.TextWrapped = true
InfoFrame.TextXAlignment = Enum.TextXAlignment.Left
InfoFrame.TextYAlignment = Enum.TextYAlignment.Top
InfoFrame.Parent = MainFrame

-- ESP Toggle button
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.9, 0, 0, 30)
ESPButton.Position = UDim2.new(0.05, 0, 0, 160)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ESPButton.TextColor3 = Color3.new(1, 1, 1)
ESPButton.TextSize = 12
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Text = "[ OFF ] ESP"
ESPButton.BorderSizePixel = 0
ESPButton.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPButton

-- Speed Toggle button
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 30)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 195)
SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedButton.TextColor3 = Color3.new(1, 1, 1)
SpeedButton.TextSize = 12
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.Text = "[ OFF ] SPEED"
SpeedButton.BorderSizePixel = 0
SpeedButton.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedButton

print("[DEBUG] UI Created")

-- ==================== FEATURE FLAGS ====================
local ESPEnabled = false
local SpeedEnabled = false
local ESPBoxes = {}
local OriginalSpeed = 16

-- ==================== CHARACTER SCANNER ====================
local function ScanPlayerStructure()
    print("\n=== SCANNING PLAYER STRUCTURE ===")
    
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            print("\n[PLAYER] " .. player.Name)
            
            local char = player.Character
            print("[CHAR CHILDREN]")
            for _, child in pairs(char:GetChildren()) do
                print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
                
                if child.ClassName == "Part" or child.ClassName == "MeshPart" then
                    for _, subchild in pairs(child:GetChildren()) do
                        print("    - " .. subchild.Name .. " (" .. subchild.ClassName .. ")")
                    end
                end
            end
        end
    end
end

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
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.MaxDistance = math.huge
    billboard.Size = UDim2.new(4, 0, 5, 0)
    billboard.Parent = rootPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
    frame.Parent = billboard
    
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
    
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            if not ESPBoxes[player] then
                CreateESPBox(player, player.Character)
            end
        end
    end
end

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

-- ==================== BUTTON CLICKS ====================
ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    print("[DEBUG] ESP Toggled: " .. (ESPEnabled and "ON" or "OFF"))
    
    if ESPEnabled then
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        ESPButton.Text = "[ ON ] ESP"
    else
        ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        ESPButton.Text = "[ OFF ] ESP"
    end
    
    UpdateESP()
end)

SpeedButton.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    print("[DEBUG] Speed Toggled: " .. (SpeedEnabled and "ON" or "OFF"))
    
    if SpeedEnabled then
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        SpeedButton.Text = "[ ON ] SPEED"
    else
        SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        SpeedButton.Text = "[ OFF ] SPEED"
    end
    
    UpdateSpeed()
end)

-- ==================== MAIN LOOP ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        UpdateESP()
        UpdateSpeed()
        
        -- Update info
        local playerCount = #Players:GetPlayers()
        InfoFrame.Text = "Players: " .. playerCount .. "\nESP: " .. (ESPEnabled and "ON" or "OFF") .. "\nSpeed: " .. (SpeedEnabled and "ON" or "OFF") .. "\nBoxes: " .. tostring(#ESPBoxes)
    end)
end)

print("[DEBUG] Loop connected")
print("✓ Script loaded!")
print("✓ Toggle ESP and Speed buttons")
