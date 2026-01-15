local TARGET_ID = "39a3c395-6b7f-4ef4-a000-860f45c06e42" -- From your first example
local TARGET_ID_2 = "b360cebe-23ef-4bcf-a0dd-0780f8d13434" -- From your second example

print("--- SEARCHING FOR IDS ---")
print("Scanning the whole game for these IDs...")
print("1. " .. TARGET_ID)
print("2. " .. TARGET_ID_2)

local function Scan(parent)
    for _, child in ipairs(parent:GetChildren()) do
        -- Check Name
        if child.Name == TARGET_ID or child.Name == TARGET_ID_2 then
            print("!!! FOUND IN NAME !!!")
            print("Path: " .. child:GetFullName())
        end

        -- Check Values
        if child:IsA("StringValue") then
            if child.Value == TARGET_ID or child.Value == TARGET_ID_2 then
                print("!!! FOUND IN STRINGVALUE !!!")
                print("Path: " .. child:GetFullName())
            end
        end

        -- Check Attributes
        local attrs = child:GetAttributes()
        for k, v in pairs(attrs) do
            if v == TARGET_ID or v == TARGET_ID_2 then
                 print("!!! FOUND IN ATTRIBUTE !!!")
                 print("Object: " .. child:GetFullName())
                 print("Attribute: " .. k)
            end
        end

        -- Recurse (avoid nil parents or locked services)
        pcall(function()
            Scan(child)
        end)
    end
end

Scan(game:GetService("Workspace"))
Scan(game:GetService("ReplicatedStorage"))
print("--- SCAN COMPLETE ---")
