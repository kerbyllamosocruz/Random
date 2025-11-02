getgenv().AutoHit = true
getgenv().HitRange = 10000

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("Combat"):WaitForChild("M1")
local LocalPlayer = Players.LocalPlayer

local HumanoidRootPart

local function updateCharacter()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end

updateCharacter()
LocalPlayer.CharacterAdded:Connect(updateCharacter)

local function getClosestMob()
	local closest, dist = nil, math.huge
	for _, mob in ipairs(Workspace.Live.MobModel:GetChildren()) do
		if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
			local mag = (mob.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
			if mag < dist and mag <= getgenv().HitRange then
				dist = mag
				closest = mob
			end
		end
	end
	return closest
end

task.spawn(function()
	while getgenv().AutoHit do
		task.wait()
		if HumanoidRootPart then
			local target = getClosestMob()
			if target then
				Remote:FireServer({ target:GetAttribute("UUID") or target.Name })
			end
		end
	end
end)
