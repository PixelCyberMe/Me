local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local normalSpeed = 16
local sprintSpeed = 30

local normalFOV = 70
local sprintFOV = 85

local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
end)

local sprinting = false

-- 🎥 плавный FOV
RunService.RenderStepped:Connect(function()
    if sprinting then
        camera.FieldOfView = camera.FieldOfView + (sprintFOV - camera.FieldOfView) * 0.1
    else
        camera.FieldOfView = camera.FieldOfView + (normalFOV - camera.FieldOfView) * 0.1
    end
end)

-- 🏃 плавная скорость (smooth sprint)
local function setSpeed(target)
    task.spawn(function()
        local start = humanoid.WalkSpeed
        local t = 0

        while t < 1 do
            t += 0.05
            humanoid.WalkSpeed = start + (target - start) * t
            task.wait()
        end

        humanoid.WalkSpeed = target
    end)
end

-- ⌨️ Shift control
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.LeftShift then
        sprinting = true
        setSpeed(sprintSpeed)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        sprinting = false
        setSpeed(normalSpeed)
    end
end)