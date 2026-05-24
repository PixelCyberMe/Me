print("Magnet loaded!")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local radius = 2000

while task.wait(0.1) do
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hrp then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                
                if v:FindFirstChild("TouchInterest") then
                    
                    local dist = (hrp.Position - v.Position).Magnitude

                    if dist <= radius then
                        
                        pcall(function()
                            firetouchinterest(hrp, v, 0)
                            firetouchinterest(hrp, v, 1)
                        end)

                    end
                end
            end
        end
    end
end