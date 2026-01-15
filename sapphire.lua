local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local ENABLE_LOOP = true      -- [SWITCH] Set to false to stop the loop
local STEP_SIZE = 8           -- Gap between lines
local WALK_SPEED = 300        -- Walking speed
local USE_TELEPORT = false     -- Teleport instead of walking

-- HARDCODED CORNERS
local corner1 = Vector3.new(-35.01, 98.03, 3909)
local corner2 = Vector3.new(83.8672, 98.01, 4025.04)

print("--- AUTO FARM LOADED ---")

-- Visual Markers (Static)
local function CreateMarker(pos, color, name)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = Vector3.new(1, 40, 1)
    p.Anchored = true
    p.CanCollide = false
    p.Color = color
    p.Transparency = 0.5
    p.Position = pos
    p.Parent = workspace
    return p
end

local p1 = CreateMarker(corner1, Color3.new(1,0,0), "Corner1")
local p2 = CreateMarker(corner2, Color3.new(0,0,1), "Corner2")

-- Calculate Bounds (Static)
local minX = math.min(corner1.X, corner2.X)
local maxX = math.max(corner1.X, corner2.X)
local minZ = math.min(corner1.Z, corner2.Z)
local maxZ = math.max(corner1.Z, corner2.Z)
local yLevel = corner1.Y

Humanoid.WalkSpeed = WALK_SPEED

local function MoveTo(targetPos)
    if not Character or not RootPart then return end
    if USE_TELEPORT then
        RootPart.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    else
        Humanoid:MoveTo(targetPos)
        Humanoid.MoveToFinished:Wait()
    end
end

-- Visual Pointer
local visual = Instance.new("Part")
visual.Size = Vector3.new(1, 5, 1)
visual.Anchored = true
visual.CanCollide = false
visual.Transparency = 0.5
visual.Color = Color3.new(0, 1, 0)
visual.Parent = workspace

print("STARTING FARM LOOP...")

while ENABLE_LOOP do
    if not Character or not Character.Parent then
        Character = LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        Humanoid.WalkSpeed = WALK_SPEED
    end
    
    -- Zig-Zag Loop
    for x = minX, maxX, STEP_SIZE do
        if not ENABLE_LOOP then break end -- Exit if disabled mid-loop
        
        -- S-Shape logic
        local zStart, zEnd, zStep = minZ, maxZ, STEP_SIZE
        if (math.floor((x - minX) / STEP_SIZE) % 2) ~= 0 then
            zStart, zEnd, zStep = maxZ, minZ, -STEP_SIZE
        end

        for z = zStart, zEnd, zStep do
            if not ENABLE_LOOP then break end
            
            local target = Vector3.new(x, yLevel, z)
            visual.Position = target
            MoveTo(target)
        end
    end
    
    if ENABLE_LOOP then
        print("Cycle complete. Restarting in 1 second...")
        task.wait(1)
    end
end

visual:Destroy()
p1:Destroy()
p2:Destroy()
print("--- FARM STOPPED ---")
