local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local STEP_SIZE = 8       -- Gap between lines (smaller = more coverage)
local WALK_SPEED = 150       -- Walking speed (User can increase this)
local USE_TELEPORT = false -- Teleport instead of walking

-- HARDCODED CORNERS
local corner1 = Vector3.new(-35.01, 98.03, 3909)
local corner2 = Vector3.new(83.8672, 98.01, 4025.04)

print("--- AUTO FARM STARTED ---")
print("Using Fixed Coordinates:")
print("C1: " .. tostring(corner1))
print("C2: " .. tostring(corner2))

-- Visual Marker 1
local p1 = Instance.new("Part")
p1.Size = Vector3.new(1, 40, 1)
p1.Anchored = true
p1.CanCollide = false
p1.Color = Color3.fromRGB(255, 0, 0) -- Red
p1.Transparency = 0.5
p1.Position = corner1
p1.Parent = workspace

-- Visual Marker 2
local p2 = Instance.new("Part")
p2.Size = Vector3.new(1, 40, 1)
p2.Anchored = true
p2.CanCollide = false
p2.Color = Color3.fromRGB(0, 0, 255) -- Blue
p2.Transparency = 0.5
p2.Position = corner2
p2.Parent = workspace

-- Calculate Bounds
local minX = math.min(corner1.X, corner2.X)
local maxX = math.max(corner1.X, corner2.X)
local minZ = math.min(corner1.Z, corner2.Z)
local maxZ = math.max(corner1.Z, corner2.Z)
local yLevel = corner1.Y -- Keep height consistent

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

print("STARTING LOOP...")

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
p1:Destroy()
p2:Destroy()
print("--- FARM FINISHED ---")
