print("Universal Interact loaded!")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

while task.wait(0.30) do
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hrp then
        for _, v in pairs(Workspace:GetDescendants()) do

            pcall(function()

                if v:IsA("ProximityPrompt") then
                    v.MaxActivationDistance = math.huge
                    v.RequiresLineOfSight = false
                    v.HoldDuration = 0

                    fireproximityprompt(v)
                end

                if v:IsA("ClickDetector") then
                    fireclickdetector(v)
                end

                if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                    firetouchinterest(hrp, v, 0)
                    firetouchinterest(hrp, v, 1)
                end

            end)
        end
    end
end