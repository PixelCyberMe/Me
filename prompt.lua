print("Hold Prompt loaded!")

local Workspace = game:GetService("Workspace")

local function doPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false

        local oldHold = prompt.HoldDuration
        prompt.HoldDuration = 0

        pcall(function()
            fireproximityprompt(prompt)
        end)

        task.wait()

        prompt.HoldDuration = oldHold

        print("Prompt triggered:", prompt.Parent.Name)
    end
end

for _, v in pairs(Workspace:GetDescendants()) do
    doPrompt(v)
end

Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.1)
    doPrompt(v)
end)