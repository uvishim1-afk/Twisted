-- ========================================
-- TWISTEDHOOK v5 - ESP DEBUG
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
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
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
Title.Text = "ESP DEBUG"
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

-- Toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 165)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "TOGGLE ESP"
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

print("[DEBUG] UI Created")

-- ==================== CHARACTER SCANNER ====================
local ESPEnabled = false
local ESPBoxes = {}

local function ScanPlayerStructure()
    print("\n=== SCANNING PLAYER STRUCTURE ===")
    
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            print("\n[PLAYER] " .. player.Name)
            
            local char = player.Character
            print("[CHAR CHILDREN]")
            for _, child in pairs(char:GetChildren()) do
                print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
                
                -- If it's a humanoid root part or similar, show its children
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
    
    -- Try different detection methods
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
    
    -- Create ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player and player ~= LocalPlayer and player.Character then
            if not ESPBoxes[player] then
                CreateESPBox(player, player.Character)
            end
        end
    end
end

-- ==================== BUTTON CLICK ====================
ToggleButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    print("[DEBUG] ESP Toggled: " .. (ESPEnabled and "ON" or "OFF"))
    
    if ESPEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        ToggleButton.Text = "ESP ON"
        print("[DEBUG] Calling UpdateESP()...")
        UpdateESP()
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        ToggleButton.Text = "TOGGLE ESP"
        UpdateESP()
    end
end)

-- ==================== AUTO SCAN BUTTON ====================
local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.4, 0, 0, 30)
ScanButton.Position = UDim2.new(0.05, 0, 0.8, 0)
ScanButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.TextSize = 11
ScanButton.Font = Enum.Font.Gotham
ScanButton.Text = "SCAN"
ScanButton.BorderSizePixel = 0
ScanButton.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

ScanButton.MouseButton1Click:Connect(function()
    ScanPlayerStructure()
end)

-- ==================== MAIN LOOP ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        UpdateESP()
        
        -- Update info
        local playerCount = #Players:GetPlayers()
        InfoFrame.Text = "Players: " .. playerCount .. "\nESP: " .. (ESPEnabled and "ON" or "OFF") .. "\nBoxes: " .. tostring(#ESPBoxes)
    end)
end)

print("[DEBUG] Loop connected")
print("✓ Debug script loaded!")
print("✓ Click TOGGLE ESP button")
print("✓ Click SCAN to see player structure")
