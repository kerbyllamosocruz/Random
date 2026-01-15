local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local GUID_PATTERN = "{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x}"

print("--- ADVANCED DEBUG SCANNER STARTED ---")
print("Walk near an item to scan for hidden IDs...")

local inspected = {}

local function ScanForGUIDs(obj, prefix)
    -- Check Attributes
    for name, value in pairs(obj:GetAttributes()) do
        if type(value) == "string" and value:match(GUID_PATTERN) then
            print(prefix .. "FOUND GUID IN ATTRIBUTE: [" .. name .. "] = " .. value)
        end
    end
    
    -- Check Children Values
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("StringValue") and child.Value:match(GUID_PATTERN) then
            print(prefix .. "FOUND GUID IN VALUE: [" .. child.Name .. "] = " .. child.Value)
        elseif child:IsA("ObjectValue") then
             print(prefix .. "Found ObjectValue: [" .. child.Name .. "] -> " .. (child.Value and child.Value.Name or "nil"))
        end
        -- Also check name of child
        if child.Name:match(GUID_PATTERN) then
             print(prefix .. "FOUND GUID IN CHILD NAME: " .. child.Name)
        end
    end
end

while true do
    if HumanoidRootPart then
        for _, item in ipairs(Workspace:GetChildren()) do -- Adjust if items are in a folder
             -- Simple check for likely interactables
            if item:IsA("Model") or (item:IsA("BasePart") and item:FindFirstChild("TouchInterest")) or item:FindFirstChild("ClickDetector") or item:GetAttribute("Interaction") then
                 
                local itemPos = nil
                if item:IsA("BasePart") then itemPos = item.Position
                elseif item:IsA("Model") and item.PrimaryPart then itemPos = item.PrimaryPart.Position
                elseif item:FindFirstChild("HumanoidRootPart") then itemPos = item.HumanoidRootPart.Position
                end

                if itemPos then
                    local distance = (HumanoidRootPart.Position - itemPos).Magnitude
                    if distance < 15 and not inspected[item] then
                        inspected[item] = true
                        print(">>> INSPECTING: " .. item.Name .. " <<<")
                        ScanForGUIDs(item, "  ")
                        
                        -- Deep scan specific children if needed
                        if item:FindFirstChild("Configuration") then
                             ScanForGUIDs(item.Configuration, "  [Config] ")
                        end
                        print("---------------------------------")
                    end
                end
            end
        end
    end
    task.wait(0.5)
end
