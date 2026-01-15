local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local RANGE = 30        -- Size of the square area (from center to edge, so 100 means 200x200 area)
local STEP_SIZE = 8      -- How many studs to move per step (smaller = precision, larger = speed)
local WALK_SPEED = 500    -- Speed of walking
local Y_OFFSET = 0       -- Keep at 0 to stay on ground
local USE_TELEPORT = true -- Set to true to teleport instead of walk (riskier, faster)

local UserInputService = game:GetService("UserInputService")

print("--- LAWNMOWER READY ---")
print("1. Stand in the CENTER of the zone.")
print("2. Press 'F' to START the script.")

-- Wait for key press
local started = false
local connection
connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        started = true
        connection:Disconnect() -- Stop listening
    end
end)

repeat task.wait() until started

print("STARTING NOW! Center set.")

local CenterPosition = RootPart.Position
Humanoid.WalkSpeed = WALK_SPEED

local function MoveTo(targetPos)
    if USE_TELEPORT then
        RootPart.CFrame = CFrame.new(targetPos)
        task.wait(0.1) -- Small delay to register touch
    else
        Humanoid:MoveTo(targetPos)
        -- Wait until we reach the point or get stuck (timeout 3s)
        local reached = Humanoid.MoveToFinished:Wait()
    end
end

-- Create a visual marker (client-side only)
local visual = Instance.new("Part")
visual.Size = Vector3.new(1, 40, 1)
visual.Anchored = true
visual.CanCollide = false
visual.Transparency = 0.5
visual.Color = Color3.fromRGB(0, 255, 0)
visual.Parent = workspace

-- Zig-Zag Pattern
for x = -RANGE, RANGE, STEP_SIZE do
    -- Flip direction every row for efficiency (S-shape)
    local zStart, zEnd, zStep = -RANGE, RANGE, STEP_SIZE
    if (x / STEP_SIZE) % 2 ~= 0 then 
        zStart, zEnd, zStep = RANGE, -RANGE, -STEP_SIZE 
    end

    for z = zStart, zEnd, zStep do
        if not Character or not Character.Parent or Humanoid.Health <= 0 then break end
        
        local target = CenterPosition + Vector3.new(x, Y_OFFSET, z)
        visual.Position = target
        MoveTo(target)
    end
end

visual:Destroy()
print("--- COLLECTION FINISHED ---")
