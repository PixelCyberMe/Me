local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local normalSpeed = 16
local sprintSpeed = 30

local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- если персонаж ресается
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
    humanoid.WalkSpeed = normalSpeed
end)

-- ⌨️ Shift = бег
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.LeftShift then
        humanoid.WalkSpeed = sprintSpeed
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        humanoid.WalkSpeed = normalSpeed
    end
end)