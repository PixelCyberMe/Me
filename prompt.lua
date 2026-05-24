print("Auto ProximityPrompt loaded!")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

for _, v in pairs(Workspace:GetDescendants()) do
    if v:IsA("ProximityPrompt") then
        v.MaxActivationDistance = 999999
        v.RequiresLineOfSight = false

        pcall(function()
            fireproximityprompt(v)
        end)
    end
end

Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ProximityPrompt") then
        v.MaxActivationDistance = 999999
        v.RequiresLineOfSight = false

        task.wait(0.1)

        pcall(function()
            fireproximityprompt(v)
        end)
    end
end)

print("All prompts modified!")