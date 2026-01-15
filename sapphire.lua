local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local STEP_SIZE = 8       -- Gap between lines (smaller = more coverage)
local WALK_SPEED = 500    -- Walking speed
local USE_TELEPORT = true -- Teleport instead of walking

print("--- AREA SELECTOR READY ---")
print("1. Stand at CORNER 1 and press 'G'")
print("2. Stand at CORNER 2 (Opposite) and press 'G'")

local corner1 = nil
local corner2 = nil
local ready = false

-- Area Setup Loop
local connection
connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        if not corner1 then
            corner1 = RootPart.Position
            print("CORNER 1 SET: " .. tostring(corner1))
            
            -- Visual Marker 1
            local p = Instance.new("Part")
            p.Size = Vector3.new(1, 40, 1)
            p.Anchored = true
            p.CanCollide = false
            p.Color = Color3.fromRGB(255, 0, 0) -- Red
            p.Transparency = 0.5
            p.Position = corner1
            p.Parent = workspace
            
            print("Now go to CORNER 2 and press 'G'")
        elseif not corner2 then
            corner2 = RootPart.Position
            print("CORNER 2 SET: " .. tostring(corner2))
            
            -- Visual Marker 2
            local p = Instance.new("Part")
            p.Size = Vector3.new(1, 40, 1)
            p.Anchored = true
            p.CanCollide = false
            p.Color = Color3.fromRGB(0, 0, 255) -- Blue
            p.Transparency = 0.5
            p.Position = corner2
            p.Parent = workspace
            
            ready = true
            connection:Disconnect()
        end
    end
end)

repeat task.wait() until ready
print("CALCULATING AREA...")

-- Calculate Bounds
local minX = math.min(corner1.X, corner2.X)
local maxX = math.max(corner1.X, corner2.X)
local minZ = math.min(corner1.Z, corner2.Z)
local maxZ = math.max(corner1.Z, corner2.Z)
local yLevel = corner1.Y -- Keep height consistent with first corner

Humanoid.WalkSpeed = WALK_SPEED

local function MoveTo(targetPos)
    if USE_TELEPORT then
        RootPart.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    else
        Humanoid:MoveTo(targetPos)
        local reached = Humanoid.MoveToFinished:Wait()
    end
end

-- Visual Tracking Part
local visual = Instance.new("Part")
visual.Size = Vector3.new(1, 5, 1)
visual.Anchored = true
visual.CanCollide = false
visual.Transparency = 0.5
visual.Color = Color3.fromRGB(0, 255, 0) -- Green
visual.Parent = workspace

print("STARTING FARM...")

-- Zig-Zag Loop within Bounds
for x = minX, maxX, STEP_SIZE do
    -- S-Shape logic
    local zStart, zEnd, zStep = minZ, maxZ, STEP_SIZE
    if (math.floor((x - minX) / STEP_SIZE) % 2) ~= 0 then
        zStart, zEnd, zStep = maxZ, minZ, -STEP_SIZE
    end

    for z = zStart, zEnd, zStep do
        if not Character or not Character.Parent or Humanoid.Health <= 0 then break end
        
        local target = Vector3.new(x, yLevel, z)
        visual.Position = target
        MoveTo(target)
    end
end

visual:Destroy()
print("--- FARM FINISHED ---")
