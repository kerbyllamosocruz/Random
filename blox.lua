local TargetName = "Chief Petty Officer" -- Put target NPC name here. (Just look at their name tag and copy exactly.)

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Modules.Net
local RegisterAttack = Net["RE/RegisterAttack"]
local RegisterHit = Net["RE/RegisterHit"]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function GetCharacter()
    return LocalPlayer.Character or (LocalPlayer.CharacterAdded:wait() and LocalPlayer.Character)
end

local function GetSessionID()
    -- Get Combat Thread
    local SendHitsToServer = getrenv()._G.SendHitsToServer
    local CombatThread = getupvalues(SendHitsToServer)[1]
    -- Construct Session ID
    local UserIDSlice = tostring(LocalPlayer.UserId):sub(2, 4)
    local MemorySlice = tostring(CombatThread):sub(11, 15)
    -- Combine The Two Parts
    local SessionID = UserIDSlice .. MemorySlice

    return SessionID
end
print("Session ID Test:", GetSessionID())

local function Attack(TargetCharacter)
    RegisterAttack:FireServer(0.5)
    task.wait()
    local dataTable = {
        TargetCharacter:WaitForChild("RightLowerLeg"),
        {},
        nil,
        GetSessionID()
    }
    RegisterHit:FireServer(unpack(dataTable))
end
local Enemies = workspace.Enemies

local RootPart = GetCharacter():WaitForChild("HumanoidRootPart")

while task.wait() do
    for i, Enemy in pairs(Enemies:GetChildren()) do
        if Enemy.Name == TargetName and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            local TargetRootPart = Enemy:FindFirstChild("HumanoidRootPart")
            if TargetRootPart then
                repeat task.wait()
                    RootPart.CFrame = CFrame.new(TargetRootPart.Position) * CFrame.new(0, 57, 0)
                    RootPart.Velocity = Vector3.zero
                    task.wait()
                    Attack(Enemy)
                until Enemy.Humanoid.Health == 0
            end
        end
    end
end
print("read")
