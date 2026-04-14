print("Camera Toggle loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local thirdPerson = false -- 👈 теперь по умолчанию 1 лицо

-- 🔒 ShiftLock
local function setShiftLock(state)
    player.DevEnableMouseLock = state
end

-- 📷 камера
local function updateCamera()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")

    if thirdPerson then
        player.CameraMode = Enum.CameraMode.Classic
        if hum then camera.CameraSubject = hum end
        print("3RD PERSON ON")
    else
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        print("1ST PERSON ON")
    end
end

-- 🔘 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CamToggleGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.Text = "1ST PERSON"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = gui

-- 🎯 toggle
button.MouseButton1Click:Connect(function()
    thirdPerson = not thirdPerson

    if thirdPerson then
        button.Text = "3RD PERSON"
        setShiftLock(true)
    else
        button.Text = "1ST PERSON"
        setShiftLock(false)
    end

    updateCamera()
end)

-- 🔄 respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    updateCamera()
end)

-- 🟢 DRAG
local dragging = false
local dragStart
local startPos
local dragInput

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- 🚀 старт
task.wait(1)
updateCamera()

print("Camera system ready!")