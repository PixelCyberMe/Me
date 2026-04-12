print("Camera Toggle loaded!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local thirdPerson = true
local dragging = false
local dragInput, dragStart, startPos

local function setShiftLock(state)
    player.DevEnableMouseLock = state
    print("ShiftLock:", state and "ON" or "OFF")
end

local function updateCamera()
    if thirdPerson then
        player.CameraMode = Enum.CameraMode.Classic
        camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
        print("Third Person ON")
    else
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        print("First Person ON")
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "CamToggleGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 50)
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.Text = "3rd PERSON"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = gui

button.MouseButton1Click:Connect(function()
    thirdPerson = not thirdPerson

    if thirdPerson then
        button.Text = "3rd PERSON"
        setShiftLock(true)
    else
        button.Text = "1st PERSON"
        setShiftLock(false)
    end

    updateCamera()
end)

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

task.wait(1)
setShiftLock(true)
updateCamera()